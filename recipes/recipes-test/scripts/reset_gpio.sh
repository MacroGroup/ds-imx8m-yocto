#!/bin/sh

for (( i=0; i <= 31; i++ ))
do
gpioget gpiochip$1 $i
done
