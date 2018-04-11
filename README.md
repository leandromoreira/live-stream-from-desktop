# Live stream from your desktop
It provides guidance to test live streaming (mpeg-dash or hls) or vod from your own desktop, it's useful for testing and learning purposes.

## MacOS

> #### Tested with:
> * MacOS High Siera 10.13

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

### Simulating a MPEG-DASH live streaming from a file

Open a terminal and run the ffmpeg command:

```
ffmpeg -stream_loop 1 -i bunny_1080p_30fps.mp4 \
       -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
       -preset superfast -profile:v baseline -level 3.0 \
       -tune zerolatency -s 1280x720 -b:v 1400k \
       -bufsize 1 -use_timeline 1 -use_template 1 \
       -init_seg_name init-\$RepresentationID\$.mp4 \ 
       -min_seg_duration 2000000 -media_seg_name test-\$RepresentationID\$-\$Number\$.mp4 \
       -f dash stream.mpd
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.mpd`).

### Simulating a HLS live streaming from a file

Open a terminal and run the ffmpeg command:

```
ffmpeg -stream_loop 1 -i bunny_1080p_30fps.mp4 -c:v libx264 \ 
          -x264opts keyint=30:min-keyint=30:scenecut=-1 \ 
          -tune zerolatency -s 1280x720 \ 
          -b:v 1400k -bufsize 1 \ 
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
       -bufsize 1 -use_timeline 1 -use_template 1 \
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
          -b:v 1400k -bufsize 1 \ 
          -hls_start_number_source epoch -f hls stream.m3u8
```

In another tab, run the following command to fire up the server:

```
http-server -a :: -p 8081 --cors -c-1
```

Now you can test this with your player (using the URL `http://localhost:8081/stream.mpd`).
