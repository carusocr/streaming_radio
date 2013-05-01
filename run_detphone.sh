#!/usr/local/bin/bash

cd /mnt/data0/streaming_sources
for mp3f in *.mp3
do
    labf=${mp3f%%.mp3}.lab
    rawf=/tmp/rdp$$\.raw
    if [[ ! -f "$labf" ]]; then
	if ! fuser -s $mp3f; then
	    echo $mp3f $labf
	    sox $mp3f -t raw -c 1 -b 16 -r 16000 $rawf && \
		detphone $rawf $labf && \
		( yes | rm $rawf )
	else
	    echo $mp3f currently open - skipping
	fi	
    fi
done

