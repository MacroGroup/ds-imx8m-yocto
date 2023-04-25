#!/bin/sh

PORT0=0
PORT3=3
PORT4=4


gpio_reset() {
    local data
    local err=0
    for GPIO in 0 4 5 11 13
    do
       data=$(gpioget gpiochip0 ${GPIO})
       if [ $data -ne 0 ]; then 
            ((err=err+1)) 
        fi
    done


    for GPIO in 21 22 23 24 25 26 27
    do
       data=$(gpioget gpiochip3 ${GPIO})
       if [ $data -ne 0 ]; then 
            ((err=err+1)) 
        fi
    done

    for GPIO in 3 4 5 6 7 8 9 10 11 12 13
    do
        data=$(gpioget gpiochip4 ${GPIO})
        if [ $data -ne 0 ]; then 
            ((err=err+1)) 
        fi
    done

    if [ $err -eq 0 ]
    then echo "0"
    else echo "1"
    fi
}

check_gpio() {
    local err=0
    local data
    gpioset $1 $2=1
    #  echo "Port $1 $2"
    for GPIO in 0 4 5 11 13
    do
        if [ $1 -eq ${PORT0} ] && [ $2 -eq ${GPIO} ]
        then
            :
        else
            data=$(gpioget gpiochip0 ${GPIO})
            # echo "Port 0 ${data}"
            if [ $data -ne 0 ]; then 
                ((err=err+1)) 
                # echo "Port 0 ${GPIO}"
            fi
        fi
    done

    for GPIO in 21 22 23 24 25 26 27
    do
        if [ $1 -eq ${PORT3} ] && [ $2 -eq ${GPIO} ]
        then
            :
        else
            data=$(gpioget gpiochip3 ${GPIO})
            if [ $data -ne 0 ]; then 
                ((err=err+1)) 
                # echo "Port 3 ${GPIO}"
            fi
        fi
    done

    for GPIO in 3 4 5 6 7 8 9 10 11 12 13
    do
        if [ $1 -eq ${PORT4} ] && [ $2 -eq ${GPIO} ]
        then
            :
        else
            data=$(gpioget gpiochip4 ${GPIO})
            if [ $data -ne 0 ]; then 
                ((err=err+1)) 
                # echo "Port 4 ${GPIO}"
            fi
        fi
    done
    gpioset $1 $2=0
    local d=$(gpioget $1 $2)

    if [ $err -eq 0 ]
    then echo "0"
    else echo "1"
    fi
}

check() {

    local err=0;
    local res;

    reset=$(gpio_reset)

    if [ ${reset} -ne 0 ]; then
        echo "Gpio check fail"
        exit 1
    fi

    for GPIO in 0 4 5 11 13
    do
        res=$(check_gpio ${PORT0} ${GPIO})
        if [ $res -ne 0 ]; then 
            ((err=err+1))
        fi
    done


    for GPIO in 21 22 23 24 25 26 27
    do
        res=$(check_gpio ${PORT3} ${GPIO})
        if [[ $res -ne 0 ]]; then 
            ((err=err+1))
        fi
    done

    for GPIO in 3 4 5 6 7 8 9 10 11 12 13
    do
        res=$(check_gpio ${PORT4} ${GPIO})
        if [ $res -ne 0 ]; then 
            ((err=err+1))
        fi
    done

    if [ $err -eq 0 ]
    then echo "Gpio check ok"
    else echo "Gpio check fail"
    fi
}

check