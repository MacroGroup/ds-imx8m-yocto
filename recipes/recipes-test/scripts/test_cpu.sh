#!/bin/bash


FILE=/home/root/temp_cpu.log
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    rm /home/root/temp_cpu.log
else 
    echo "$FILE does not exist."
fi

cat /sys/devices/virtual/thermal/thermal_zone0/temp > /home/root/temp_cpu.log
sysbench --test=cpu --cpu-max-prime=20000 run
sysbench --test=memory run
stress-ng --cpu 4 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
cat /sys/devices/virtual/thermal/thermal_zone0/temp >> /home/root/temp_cpu.log