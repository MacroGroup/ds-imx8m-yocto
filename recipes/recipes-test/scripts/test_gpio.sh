#!/bin/sh

PORT0=0
PORT3=3
PORT4=4

check_pair() {
    local err=0;
    # echo "Gpio reseting $1 $2"
    local data;
    for GPIO in $2 $3
    do
        data=$(gpioget gpiochip$1 ${GPIO})
    done
    gpioset gpiochip$1 $2=0
    b=$(gpioget gpiochip$1 $3)
    if [ $b -ne 0 ]
    then ((err=err+1))
    fi

    gpioset gpiochip$1 $2=1
    b=$(gpioget gpiochip$1 $3)
    if [ $b -ne 1 ]
    then ((err=err+1))
    fi

    if [ $err -eq 0 ]
    then echo "0"
    else echo "1"
    fi
}

check_triple()
{
    local err=0;
    # echo "Gpio reseting $1 $2"
    local data;
    for GPIO in $2 $3 $4
    do
        data=$(gpioget gpiochip$1 ${GPIO})
    done
    gpioset gpiochip$1 $2=0
    b=$(gpioget gpiochip$1 $3)
    if [ $b -ne 0 ]
    then ((err=err+1))
    fi

    b=$(gpioget gpiochip$1 $4)
    if [ $b -ne 0 ]
    then ((err=err+1))
    fi

    gpioset gpiochip$1 $2=1
    b=$(gpioget gpiochip$1 $3)
    if [ $b -ne 1 ]
    then ((err=err+1))
    fi

    b=$(gpioget gpiochip$1 $4)
    if [ $b -ne 1 ]
    then ((err=err+1))
    fi

    if [ $err -eq 0 ]
    then echo "0"
    else echo "1"
    fi
}

test() {
    local res=$(check_pair $1 $2 $3)
    if [ $res -eq 0 ]
    then 
        res=$(check_pair $1 $3 $2)
        if [ $res -eq 0 ]
        then echo "Gpio port $1 pin $2 pin $3 okay"
        else echo "Gpio port $1 pin $2 pin $3 error"
        fi
    else echo "Gpio port $1 pin $2 pin $3 error"
    fi
}

test_2() {
    local res=$(check_triple $1 $2 $3 $4)
    if [ $res -eq 0 ]
    then 
        res=$(check_triple $1 $3 $2 $4)
        if [ $res -eq 0 ]
        then 
            res=$(check_triple $1 $4 $3 $2)
            if [ $res -eq 0 ]
            then echo "Gpio port $1 pin $2 pin $3 pin $4 okay"
            else echo "Gpio port $1 pin $2 pin $3 pin $4 error"    
            fi 
        else echo "Gpio port $1 pin $2 pin $3 pin $4 error"
        fi
    else echo "Gpio port $1 pin $2 pin $3 pin $4 error"
    fi
}

test $PORT0 0 4
test_2 $PORT0 5 11 13

test $PORT3 22 24
test $PORT3 23 25
test_2 $PORT3 21 26 27

test $PORT4 6 7
test $PORT4 8 9
test $PORT4 10 11
test $PORT4 12 13

test_2 $PORT4 3 4 5

