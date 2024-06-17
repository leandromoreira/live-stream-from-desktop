#!/bin/bash

cd /tmp/

docker run --rm -v /tmp/:/files jrottenberg/ffmpeg:4.4-alpine -hide_banner \
  -y \
  -f webm_dash_manifest -live 1 \
  -i /files/glass_720.hdr \
  -f webm_dash_manifest -live 1 \
  -i /files/glass_360.hdr \
  -f webm_dash_manifest -live 1 \
  -i /files/glass_audio.hdr \
  -c copy \
  -map 0 -map 1 -map 2 \
  -f webm_dash_manifest -live 1 \
  -adaptation_sets "id=0,streams=0,1 id=1,streams=2" \
  -chunk_start_index 1 \
  -chunk_duration_ms 2000 \
  -time_shift_buffer_depth 7200 \
  -minimum_update_period 7200 \
  /files/glass_live_manifest.mpd

