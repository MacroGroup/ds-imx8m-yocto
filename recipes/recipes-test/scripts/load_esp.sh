#!/bin/sh

rm -rf esptool
tar -xvf esptool.tar.gz

echo 0 > /sys/class/leds/esp32_power_up/brightness
echo 0 > /sys/class/leds/esp32_boot_opt/brightness
echo 1 > /sys/class/leds/esp32_power_up/brightness

python3 esptool/esptool.py -p /dev/ttymxc0 -b 115200 --chip esp32  write_flash --flash_freq 40m 0x1000 bootloader.bin 0x8000 partition-table.bin 0x10000 scan.bin

echo 0 > /sys/class/leds/esp32_power_up/brightness
echo 1 > /sys/class/leds/esp32_boot_opt/brightness
echo 1 > /sys/class/leds/esp32_power_up/brightness

minicom -D /dev/ttymxc0
