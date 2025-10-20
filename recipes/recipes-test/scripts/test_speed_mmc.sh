#!/usr/bin/sh


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
BRIGHT_BLUE='\033[0;94m'
NC='\033[0m'

# Функции для цветного вывода
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

test_mmc_get_block_device() {
        local devtype="$1"

        local block
        for block in /sys/block/mmcblk*; do
                local block_name block_dev
                block_name=$(basename "$block")
                block_dev="/dev/$block_name"

                if [ ! -f "$block/device/type" ]; then
                        continue
                fi

                local type
                type=$(cat "$block/device/type" 2>/dev/null)
                if [ "$type" != "$devtype" ]; then
                        continue
                fi

                echo "$block_dev"

                return 0
        done

        error "Missing"

        return 1
}

test_mmc_read_speed() {
        local devtype="$1"
        local block_dev
        block_dev=$(test_mmc_get_block_device "$devtype")
        local ret=$?

        if [ $ret -ne 0 ]; then
                echo "$block_dev"
                return $ret
        fi

        local fio_output
        fio_output=$(fio --name=read_test --filename="$block_dev" --rw=read \
                --ioengine=libaio --direct=1 --iodepth=4 --bs=128k \
                --size=64M --runtime=2 --time_based --group_reporting \
                --output-format=json 2>/dev/null)

        local read_speed
        if read_speed=$(echo "$fio_output" | python3 -c "import json, sys; \
                data = json.loads(sys.stdin.read()); \
                print(data['jobs'][0]['read']['bw'])"); \
                then

                read_speed=$(echo "scale=2; $read_speed / 1024" | bc)
                local min_speed
                if [ "$devtype" = "SD" ]; then
                        min_speed=10
                else
                        min_speed=60
                fi

                info "Minimal speed ${min_speed} MB/s"
                info "Actual speed ${read_speed} MB/s"

                if [ $(echo "$read_speed > $min_speed" | bc) -eq 1 ]; then
                        success "Speed okay"
                        return 0
                else
                        error "Speed not okay"
                        return 2
                fi
        fi

        error "Error"

        return 1
}


test_mmc_read_speed "MMC"

exit 0
