#!/usr/bin/perl


use Proc::Killall;
use XML::Simple;
use Data::Dumper;
use constant SRCCFG => '/mnt/data0/bin/streaming/getstream.xml';
use constant SU => '/bin/su';
use constant SU_NAME => 'zug';
use constant CVLC => '/usr/bin/cvlc';
use constant RECDIR => '/mnt/data0/streaming_sources';
use constant CTRLHOST => 'localhost';
use constant RECDUR => 1700;

my %soutarry = ( transcode => { acodec     => 'mp3',
				ab         => '128',
				channels   => '2',
				samplerate => '44100' },
		 std       => { access     => 'file',
		                mux        => 'raw',
		                dst        => undef });

###
my $streamfile = "getstream.xml";
my $xml = new XML::Simple;
my $stream_config = $xml->XMLin("$streamfile");
my $teststr = $stream_config->{SrcDef}->{Src}->{$ARGV[0]};
print "$teststr\n";
print Dumper($stream_config);

#TESTING BREAK
exit;

my $src = shift;
die "No such source defined $src\n" unless exists($srctbl{$src});
my $duration = RECDUR;
my $url = $srctbl{$src}{stream_url};
my $ofil = sprintf("%s/%s_%s_%s.mp3", 
		   RECDIR,
		   tsprefix(),
		   $src,
		   $srctbl{$src}{iso639});
unlink($ofil) if -e $ofil;

$soutarry{std}{dst} = $ofil;

my $soutstr = sprintf("'#%s{%s}:%s{%s}'",
		      'transcode', 
		      soutfmt(\%soutarry, 'transcode'),
		      'std', 
		      soutfmt( \%soutarry, 'std'));

my @cvlc_args = ('--http-caching','3000',
		 '--codec','ffmpeg',
		 $url, '--sout',$soutstr );

eval {

    my $ccc = sprintf("%s -l %s -c %s%s%s 2>&1 >%s",
		      SU, SU_NAME,'"', join(' ',CVLC,@cvlc_args), '"', "/dev/null" );

    $SIG{ALRM} = sub { 
	my $rtn = killall('KILL',$ofil);
	print " $ofil capture processes killed : $rtn\n";
	exit;
    };
    alarm($duration);

    my $vlcpid = fork();
    if($vlcpid == 0){ exec($ccc) }
    for(;;){
	$fsiz = -s $ofil;
	print "$fsiz\n";
	sleep(1);
    }
    
};

print $@ . " " . $src ."done ...\n";

sub tsprefix {
    my ($ss,$mi,$hr,$dy,$mt,$yr) = localtime();
    return(sprintf("%0.4d%0.2d%0.2d_%0.2d%0.2d%0.2d",
		   $yr+1900,$mt+1,$dy,$hr,$mi,$ss));
}

sub soutfmt {
    my ($ar,$ky) = @_;
    my @rtn = map { my $n = join('=',$_,$ar->{$ky}->{$_});$_ = $n; } keys(%{ $ar->{$ky} });
    return(join(',',@rtn));
}
