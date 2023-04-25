#!/bin/sh

echo 0 > /sys/class/leds/esp32_power_up/brightness
echo 0 > /sys/class/leds/esp32_boot_opt/brightness
echo 1 > /sys/class/leds/esp32_power_up/brightness
