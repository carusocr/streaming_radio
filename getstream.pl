#!/usr/bin/perl


use Proc::Killall;
use constant SRCCFG => '/mnt/data0/bin/streaming/getstream.xml';
use constant SU => '/bin/su';
use constant SU_NAME => 'zug';
use constant CVLC => '/usr/bin/cvlc';
use constant RECDIR => '/mnt/data0/streaming_sources';
use constant CTRLHOST => 'localhost';
use constant RECDUR => 1700;

my %srctbl = (pubtalkctfm     => { stream_url => 'http://80.245.113.11:8004',
				   iso639 => 'ukr' },
	      chiangmaifm     => { stream_url => 'http://prdonline.prd.go.th:8118',
				   iso639     => 'tha' },
              srndhammayut    => { stream_url => 'http://210.1.61.28:9120',
				   iso639     => 'tha' },
	      thai_js100      => { stream_url => 'http://203.146.129.246:2080',
				   iso639     => 'tha' },	      
              lao_natlrad     => { stream_url => 'http://203.110.64.28:7000',
				   iso639     => 'lao' },
              freqvence       => { stream_url => 'http://icecast4.play.cz/frekvence1-128.mp3',
				   iso639     => 'ces' },
	      radio_pohadka   => { stream_url => 'http://pes.limemedia.cz/cm_pohadka',
				   iso639     => 'ces' },
	      litera_live     => { stream_url => 'http://live.slovakradio.sk:8000/Litera_128.mp3',
				   iso639     => 'slk' },
	      banska_bystrica => { stream_url => 'http://live.slovakradio.sk:8000/Regina_BB_128.mp3',
		                   iso639     => 'slk' },
	      slkradio_live   => { stream_url => 'http://live.slovakradio.sk:8000/RSI_128.mp3',
				   iso639     => 'slk' },
	      cesky_leonardo  => { stream_url => 'http://stream.rozhlas.cz:8000/leonardo_low.mp3',
				   iso639     => 'ces' },
              cesky_brno      => { stream_url => 'http://netshow4.play.cz/crobrno64',
	                           iso639     => 'ces' },
	      rana_fm         => { stream_url => 'http://216.221.73.213:8000',
				   iso639     => 'pus' },
	      radio_farda     => { stream_url => 'http://a1790.l211020637.c2110.g.lm.akamaistream.net/D/1790/2110/v0001/reflector:20637',
				   iso639     => 'fas' },
	      bangla_betar    => { stream_url => 'http://www.betar.org.bd/New/newsb.mp3',
				   iso639     => 'ben' },
	      rj_israr        => { stream_url => 'http://64.202.98.132:6240',
				   iso639     => 'urd' });

my %soutarry = ( transcode => { acodec     => 'mp3',
				ab         => '128',
				channels   => '2',
				samplerate => '44100' },
		 std       => { access     => 'file',
		                mux        => 'raw',
		                dst        => undef });


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
