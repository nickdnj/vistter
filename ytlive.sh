#!/bin/bash -x


STREAM_TIME=1800
ROTATION=90
REGION=0.25,0.25,0.5,0.5
YOUTUBE_URL="rtmp://x.rtmp.youtube.com/live2/94qu-5jkb-fa8x-a1e2"

ytlive()
{
	RST=$((STREAM_TIME*1000))
	raspivid -o - -t $RST -rot $ROTATION -roi $REGION -vf -hf -fps 30 -b 6000000 |\
 	/usr/local/bin/ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 \
 	-i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 \
	-strict experimental -t $STREAM_TIME -f flv $YOUTUBE_URL; 
	echo "Note: raspivid and ffmpeg ended at `date` ">>/root/crashed.log
	sleep 45
}

CRASH_COUNT=0
while :
do
	until ytlive; do
	
        	if [  $CRASH_COUNT -lt 3 ]; then
                	echo "Warning: Raspivid crashed with exit code $?. At `date`, Respawning.." >>/root/crashed.log
                	/sbin/ifdown 'wlan0'
                	sleep 10
                	/sbin/ifup --force 'wlan0'
                	CRASH_COUNT=`expr CRASH_COUNT + 1`
	
                	sleep 120
         	else
			echo "Error:Rebooting at `date` " >>/root/crashed.log
                	sleep 120
                	/sbin/reboot --reboot
        	fi
	done
done
