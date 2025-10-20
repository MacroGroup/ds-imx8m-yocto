#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
BRIGHT_BLUE='\033[0;94m'
NC='\033[0m'


error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BRIGHT_BLUE}[INFO]${NC} $1"
}

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
        if [ $res -eq 0 ] ;
            then 
                success "Gpio port $1 pin $2 pin $3 okay"
                return 0
            else 
                error "Gpio port $1 pin $2 pin $3 error"
                return 1
        fi
    else 
        error "Gpio port $1 pin $2 pin $3 error"
        return 1
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
            if [ $res -eq 0 ];  then 
                success "Gpio port $1 pin $2 pin $3 pin $4 okay"
                return 0
            else 
                error "Gpio port $1 pin $2 pin $3 pin $4 error"    
                return 
            fi 
        else 
            error "Gpio port $1 pin $2 pin $3 pin $4 error"
            return 1
        fi
    else 
        error "Gpio port $1 pin $2 pin $3 pin $4 error"
        return 1
    fi
}

err=0
err+=$(test $PORT0 0 4)
err+=$(test_2 $PORT0 5 11 13)

err+=$(test $PORT3 22 24)
err+=$(test $PORT3 23 25)
err+=$(test_2 $PORT3 21 26 27)

err+=$(test $PORT4 6 7)
err+=$(test $PORT4 8 9)
err+=$(test $PORT4 10 11)
err+=$(test $PORT4 12 13)

err+=$(test_2 $PORT4 3 4 5)

if [ $err -eq 0 ]; then 
    success "Gpio check okay"
else
    error "Gpio check error"
fi


