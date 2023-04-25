#!/bin/sh

I2C_ERR=0 

check_bridge() {
    RESULT=""
    RESULT=$(dmesg | grep "Probe failed. Remote port 'mipi_dsi@32e10000' disabled")

    if [ ${#RESULT} -gt 1 ]; then
        RESULT="Bridge for dsi not found"
        ((I2C_ERR=I2C_ERR+1))
    else
        RESULT="Bridge for dsi found"
        
    fi
    echo $RESULT
}

check_camera() {
    RESULT=""
    RESULT=$(dmesg | grep "Camera is found")

    if [ ${#RESULT} -gt 1 ]; then
        RESULT="CAMERA found"
    else
        RESULT="CAMERA not found"
        ((I2C_ERR=I2C_ERR+1))
    fi
    echo $RESULT
}

check_eeprom() {
    RESULT=""
    RESULT=$(i2cdetect -r -y 2 | grep " 64")

    if [ ${#RESULT} -gt 1 ]; then
        RESULT="EEPROM found"
    else
        RESULT="EEPROM not found"
        ((I2C_ERR=I2C_ERR+1))
    fi
    echo $RESULT
}

check_i2c() {
    echo
    echo "I2C test"
    echo "----------------------------------------"
    
    check_bridge
    check_camera
    check_eeprom

    if [[ $I2C_ERR -gt 0 ]]; then
        RESULT="I2C FAILED"
    else
        RESULT="I2C OK"
    fi
    echo $RESULT
    echo "----------------------------------------"
}

check_i2c