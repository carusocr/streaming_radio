day=`date -d 'yesterday' +%Y%m%d`
procdir="/lre14-collection/audio/incoming"
for i in `ls /v20/bn_collection/$day*A.wav | sed s/.wav//`; do
  echo -e "Processing $i...\n"
  `flac $i.wav -o $procdir/$i.flac`  
done
