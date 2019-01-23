#!/bin/bash

cd /tmp/

finish()
{
  rm -rf *ts
  rm -rf *m3u8
  rm -rf OpenSans-Bold.ttf
  cd -
}

trap finish EXIT

wget -q https://github.com/google/fonts/raw/master/apache/opensans/OpenSans-Bold.ttf -O OpenSans-Bold.ttf

docker run --rm -it -v $(pwd):/files jrottenberg/ffmpeg:4.1 \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -vf "drawtext=fontfile='/files/OpenSans-Bold.ttf':text='%{localtime}:box=1:fontcolor=black:boxcolor=white:fontsize=100':x=40:y=400'" \
        -hls_time 1 -hls_list_size 240 -hls_start_number_source epoch -f hls /files/stream.m3u8

