#!/bin/bash

cd /tmp/

finish()
{
  rm -rf  *m4s
  cd -
}

trap finish EXIT

docker run --rm -v /tmp/:/files jrottenberg/ffmpeg:4.1 -hide_banner \
  -re -f lavfi -i "testsrc2=size=1280x720:rate=30,format=yuv420p" \
  -f lavfi -i "sine=frequency=1000:sample_rate=48000" \
  -c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
  -b:v:0 1400k -bufsize 2800k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
  -b:v:1 700k -s:v:1 640:360 -bufsize 1500k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
  -map 0:v:0 -map 0:v:0 \
  -c:a libfdk_aac -profile:a aac_low -b:a 64k \
  -map 1:a:0 \
  -f dash -use_timeline 1 -use_template 1 -seg_duration 5 -window_size 250 \
  -utc_timing_url "https://time.akamai.com/?iso" \
  -adaptation_sets "id=0,streams=0,1 id=2,streams=a" \
  /files/out.mpd
