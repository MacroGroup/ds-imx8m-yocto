#!/bin/bash

while true
do
gst-launch-1.0 v4l2src device='/dev/video0' ! video/x-raw,width=1920,height=1080,framerate=30/1 ! waylandsink -v &
sleep $1
killall gst-launch-1.0
break
done

exit 0