#!/bin/bash

source check_dependencies.sh

cd /tmp/

finish()
{
  # Your cleanup code here
  rm -rf *m4s
  rm -rf *mpd
  rm -rf OpenSans-Bold.ttf
  cd -
}

# clean the data pro
trap finish EXIT

#cleaning up old m3u8 and ts files
rm -rf *m4s
rm -rf *mpd

wget -q https://github.com/google/fonts/raw/master/apache/opensans/OpenSans-Bold.ttf -O OpenSans-Bold.ttf

docker run --rm -it -v $(pwd):/files jrottenberg/ffmpeg:4.1 \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -vf "drawtext=fontfile='/files/OpenSans-Bold.ttf':text='%{localtime}:box=1:fontcolor=black:boxcolor=white:fontsize=100':x=40:y=400'" \
	-utc_timing_url "https://time.akamai.com/?iso" -use_timeline 0 -media_seg_name 'chunk-stream-$RepresentationID$-$Number%05d$.m4s' \
        -init_seg_name 'init-stream1-$RepresentationID$.m4s' \
        -window_size 5  -extra_window_size 10 -remove_at_exit 1 -adaptation_sets "id=0,streams=v id=1,streams=a" -f dash /files/stream.mpd
