#!/bin/bash
valid=true
count=1

while [ $valid ]
do

ffmpeg -thread_queue_size 2048 -t 00:30:00 -i "rtsp://Condo146:Wharfside@192.168.86.222/live" -f lavfi -i anullsrc -v
codec copy -acodec aac -shortest  -f flv rtmp://a.rtmp.youtube.com/live2/

echo $count >> /tmp/streamcnt.txt

done

