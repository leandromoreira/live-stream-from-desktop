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
  -re -f lavfi -i "testsrc2=size=1280x720:rate=30,format=yuv420p" \
  -f lavfi -i "sine=frequency=1000:sample_rate=4800" \
  -c:a libfdk_aac -profile:a aac_low -b:a 64k \
  -c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
  -b:v 1400k -bufsize 2800k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
  -filter_complex \
    "[0:v]split=2[s0][s1]; \
     [s0]scale=1280:-2[v0]; \
     [s1]scale=640:-2[v1]" \
  -map "[v0]" -map 1:a -map "[v1]" -map 1:a \
  -f hls -hls_time 5 -hls_list_size 50 -var_stream_map "v:0,a:0 v:1,a:1" -master_pl_name master.m3u8 \
  -hls_segment_filename '/files/vs%v/file_%03d.ts' /files/vs%v/out.m3u8
