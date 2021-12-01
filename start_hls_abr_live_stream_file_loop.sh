#!/bin/bash

cd /tmp/

finish()
{
  rm -rf vs*/*ts
  rm -rf vs*/*m3u8
  rm -rf master.m3u8
  cd -
}

trap finish EXIT

docker run --rm -v /tmp/:/files jrottenberg/ffmpeg:4.1 -hide_banner \
  -re -stream_loop -1 -i /files/short_bbb.mp4 \
  -c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
  -b:v:0 2400k -bufsize 2800k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
  -b:v:1 1400k -s:v:1 640:360 -bufsize 1700k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
  -map 0:v:0 -map 0:v:0 \
  -c:a libfdk_aac -profile:a aac_low -b:a 128k \
  -map 0:a:0 \
  -f hls -hls_time 5 -hls_list_size 50 -var_stream_map "v:0,a:0 v:1,a:0" -master_pl_name master.m3u8 \
  -hls_segment_filename '/files/vs%v/file_%03d.ts' /files/vs%v/out.m3u8
