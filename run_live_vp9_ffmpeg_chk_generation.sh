#!/bin/bash

cd /tmp/
rm -rf  *chk
rm -rf  *hdr
rm -rf  *mpd

finish()
{
  rm -rf  *chk
  rm -rf  *mpd
  rm -rf  *hdr
  cd -
}

trap finish EXIT

VP9_LIVE_PARAMS="-speed 6 -tile-columns 4 -frame-parallel 1 -threads 8 -static-thresh 0 -max-intra-rate 300 -deadline realtime -lag-in-frames 0 -error-resilient 1"

wget -q https://github.com/0xType/0xProto/releases/download/2.100/0xProto_2_100.zip -O fonts.zip
unzip -o fonts.zip

docker run --rm -v /tmp/fonts/:/usr/share/fonts -v /tmp/:/files jrottenberg/ffmpeg:4.4-alpine -hide_banner \
  -re -f lavfi -i "testsrc2=size=1280x720:rate=30,format=yuv420p" \
  -f lavfi -i "sine=frequency=1000:sample_rate=48000" \
  -map 0:0 \
  -c:v libvpx-vp9 \
  -keyint_min 60 -g 60 ${VP9_LIVE_PARAMS} \
  -b:v 1400k -bufsize 2800k \
  -vf "drawtext=text='VP9/Opus Live Streaming %{localtime}':box=1:boxborderw=10:x=(w-text_w)/2:y=(h-text_h)/2:fontsize=42:fontcolor=black" \
  -f webm_chunk \
  -header "/files/glass_360.hdr" \
  -chunk_start_index 1 \
  /files/glass_360_%d.chk \
  -map 1:0 \
  -c:a libvorbis \
  -b:a 128k -ar 48000 \
  -f webm_chunk \
  -audio_chunk_duration 2000 \
  -header /files/glass_171.hdr \
  -chunk_start_index 1 \
  /files/glass_171_%d.chk
