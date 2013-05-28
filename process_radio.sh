day=`date -d 'yesterday' +%Y%m%d`
procdir="/lre14-collection/audio/incoming"
for i in `ls $day*mp3 | sed s/.mp3//`; do
  echo -e "Processing $i.mp3...\n"
  `ffmpeg -i $i.mp3 -ar 16000 -ac 1 -n $procdir/$i.flac 2>> conv.log`
done
