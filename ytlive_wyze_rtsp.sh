#!/bin/bash
valid=true
count=1
YOUTUBE_URL="rtmp://x.rtmp.youtube.com/live2/YOUTUBE_LIVE_KEY"

while [ $valid ]
do

ffmpeg -thread_queue_size 2048 -t 00:30:00 -i "rtsp://<username>:<password>192.168.86.222/live" -f lavfi -i anullsrc -v
codec copy -acodec aac -shortest  -f flv $YOUTUBE_URL

echo $count >> /tmp/streamcnt.txt

done

