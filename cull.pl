#!/usr/bin/perl

use strict;
use File::Copy;
use constant PROJDIR => '/ldc/projects/lre/LRE11/sr-aud-ldc';
use constant COLLDIR => '/mnt/data0/streaming_sources';
die "No such project dir\n" unless -d PROJDIR;
die "project dir is not writable\n" unless -w PROJDIR;

chdir(COLLDIR) || die "$!";
opendir SD,"." || die "$!";
my @labs = grep { -f && /\.lab$/ } readdir(SD);
closedir SD;

open CF,">cull.out" || die "$!";
foreach my $labf(@labs){
    my $disp = 0;
    my $phonec = 0;
    my $mp3f = join('.',($labf =~ /(.*)\.lab$/),"mp3");
    my $tgt = join('/',PROJDIR,($labf =~ /_(\w{3})\.lab/),$mp3f);

    if(-f $mp3f){

	open LABF,"$labf" || die "$!";
	while(<LABF>){
	    ++$phonec if /phone/;
	}
	close(LABF);

	if($phonec == 0){
	    ++$disp;
	    print CF "please remove $mp3f :: no phone band speech\n";
	} else {
	    if( -f $tgt ){
		print CF "please remove $mp3f :: already in project dir\n";
	    } else {
		++$disp;
		print CF "please move $mp3f to $tgt\n";
	    }
	}
    } else { unlink($labf) }

}

close(CF);
