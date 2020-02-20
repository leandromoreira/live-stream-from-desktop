# Live stream from your desktop
It provides guidance to test live streaming (mostly RTMP, mpeg-dash or hls) or vod from your own desktop using [FFmpeg](https://ffmpeg.org/), it's pretty useful for testing and learning purposes.

## MacOS

> #### Tested with:
> * MacOS High Siera 10.13, 10.15.2, Ubuntu 18.04
> * **Warning:** The video asset used for looping streaming is more than hundreds of MBs.

### Requirements

```bash
docker
wget
curl
```

### Simulating an HLS and MPEG-DASH live streaming for latency comparison

#### HLS

Run this server in one of your tabs:
```bash
curl -s https://raw.githubusercontent.com/leandromoreira/live-stream-from-desktop/master/start_http_server.sh | sh
```
Run this encoder in another of your tabs:
```bash
curl -s https://raw.githubusercontent.com/leandromoreira/live-stream-from-desktop/master/start_hls_low_latency_live_stream.sh | sh
```
Access the stream at http://localhost:8080/stream.m3u8 or at [clappr's demo page](http://clappr.io/demo/#dmFyIHBsYXllckVsZW1lbnQgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgicGxheWVyLXdyYXBwZXIiKTsKCnZhciBwbGF5ZXIgPSBuZXcgQ2xhcHByLlBsYXllcih7CiAgc291cmNlOiAnaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0cmVhbS5tM3U4JywKICBwb3N0ZXI6ICdodHRwOi8vY2xhcHByLmlvL3Bvc3Rlci5wbmcnLAogIGhsc2pzQ29uZmlnOiB7bGl2ZVN5bmNEdXJhdGlvbkNvdW50OiAyfSwKICBhdXRvUGxheTogdHJ1ZSwKICBtdXRlOiB0cnVlLAogIGhlaWdodDogMzYwLAogIHdpZHRoOiA2NDAKfSk7CgpwbGF5ZXIuYXR0YWNoVG8ocGxheWVyRWxlbWVudCk7Cgp2YXIgcCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoInAiKTsKcC5zdHlsZS5jc3NUZXh0ID0gInotaW5kZXg6IDk5OTk5OTsgcG9zaXRpb246YWJzb2x1dGU7IHJpZ2h0OjA7IHRvcDowOyBmb250LXNpemU6IDM0cHg7IGNvbG9yOiBibGFjazsgYmFja2dyb3VuZC1jb2xvcjogd2hpdGU7IiA7CmRvY3VtZW50LmJvZHkucHJlcGVuZChwKTsKbXlJbnRlcnZhbElEID0gc2V0SW50ZXJ2YWwoKCk9PiBwLmlubmVyVGV4dCA9IG5ldyBEYXRlKCkudG9Mb2NhbGVTdHJpbmcoKSwgMTAwMCk7)


#### MPEG-DASH

Run this server in one of your tabs:
```bash
curl -s https://raw.githubusercontent.com/leandromoreira/live-stream-from-desktop/master/start_http_server.sh | sh
```
Run this encoder in another of your tabs:
```bash
curl -s https://raw.githubusercontent.com/leandromoreira/live-stream-from-desktop/master/start_mpeg_dash_low_latency_live_stream.sh | sh
```
Access the stream at http://localhost:8080/stream.mpd

### Requirements

```bash
# I assume you have brew already

# or you could use curl
brew install wget
brew install ffmpeg
brew install node

# the http server
npm install http-server -g

#  WARNING IT IS A HUGE download file (263M)
wget -O bunny_1080p_30fps.mp4 http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_30fps_normal.mp4

```

### Sending live RTMP from your local machine

#### Single Bitrate 

From a pseudo FFmpeg video source color bar and generated audio signal made of a sine wave with amplitude 1/8. 

```
ffmpeg -hide_banner \
-re -f lavfi -i "testsrc2=size=1280x720:rate=30,format=yuv420p" \
-f lavfi -i "sine=frequency=1000:sample_rate=4800" \
-c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
-b:v 1400k -bufsize 2800k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
-c:a aac -b:a 128k -f flv rtmp://<HOST>:1935/live/<STREAM>
```

From a file. 

```
ffmpeg -stream_loop -1 \
-re -i <YOUR_VIDEO>.mp4  -c:v libx264 \
-x264opts keyint=30:min-keyint=30:scenecut=-1 -tune zerolatency \
-s 1280x720 -b:v 1400k -bufsize 2800k \
-f flv rtmp://<HOST>:1935/live/<STREAM>
```

#### Multiple Bitrates 

From a pseudo FFmpeg video source color bar and generated audio signal made of a sine wave with amplitude 1/8. 

```
ffmpeg -hide_banner \
-re -f lavfi -i "testsrc2=size=1280x720:rate=30,format=yuv420p" \
-f lavfi -i "sine=frequency=1000:sample_rate=4800" \
-c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
-b:v 1400k -bufsize 2800k -x264opts keyint=30:min-keyint=30:scenecut=-1 \
-c:a aac -b:a 128k -f flv rtmp://<HOST>:1935/live/<STREAM> \
-c:v libx264 -preset ultrafast -tune zerolatency -profile:v high \
-b:v 750k -bufsize 1500k -s 640x360 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
-c:a aac -b:a 128k -f flv rtmp://<HOST>:1935/live/<STREAM> 
```

From a file. 

```
ffmpeg -stream_loop -1 \
-re -i <YOUR_VIDEO>.mp4  -c:v libx264 \
-x264opts keyint=30:min-keyint=30:scenecut=-1 -tune zerolatency \
-s 1280x720 -b:v 1400k -bufsize 2800k \
-f flv rtmp://<HOST>:1935/live/<STREAM> \
-x264opts keyint=30:min-keyint=30:scenecut=-1 -tune zerolatency \
-s 640x360 -b:v 750k -bufsize 1500k \
-f flv rtmp://<HOST>:1935/live/<STREAM>
```

### Simulating a MPEG-DASH live streaming from a file

Open a terminal and run the ffmpeg command:

```
ffmpeg -stream_loop -1 -re -i bunny_1080p_30fps.mp4 \
       -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
       -preset superfast -profile:v baseline -level 3.0 \
       -tune zerolatency -s 1280x720 -b:v 1400k \
       -bufsize 1400k -use_timeline 1 -use_template 1 \
       -init_seg_name init-\$RepresentationID\$.mp4 \
       -min_seg_duration 2000000 -media_seg_name test-\$RepresentationID\$-\$Number\$.mp4 \
       -f dash stream.mpd
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.mpd`).

### Simulating an HLS live streaming from a file

Open a terminal and run the ffmpeg command:

```
ffmpeg -stream_loop -1 -re -i bunny_1080p_30fps.mp4 -c:v libx264 \
          -x264opts keyint=30:min-keyint=30:scenecut=-1 \
          -tune zerolatency -s 1280x720 \
          -b:v 1400k -bufsize 1400k \
          -hls_start_number_source epoch -f hls stream.m3u8
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.m3u8`).

### Simulating a MPEG-DASH live streaming from MacOS camera

Open a terminal and run the ffmpeg command:

```
ffmpeg -re -pix_fmt uyvy422 -f avfoundation -i "0" -pix_fmt yuv420p \
       -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
       -preset superfast -profile:v baseline -level 3.0 \
       -tune zerolatency -s 1280x720 -b:v 1400k \
       -bufsize 1400k -use_timeline 1 -use_template 1 \
       -init_seg_name init-\$RepresentationID\$.mp4 \
       -min_seg_duration 2000000 -media_seg_name test-\$RepresentationID\$-\$Number\$.mp4 \
       -f dash stream.mpd
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.mpd`).

### Simulating a HLS live streaming from MacOS camera


Open a terminal and run the ffmpeg command:

```
ffmpeg -re -pix_fmt uyvy422 -f avfoundation -i "0" -pix_fmt yuv420p \
          -x264opts keyint=30:min-keyint=30:scenecut=-1 \
          -tune zerolatency -s 1280x720 \
          -b:v 1400k -bufsize 1400k \
          -hls_start_number_source epoch -f hls stream.m3u8
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.mpd`).
