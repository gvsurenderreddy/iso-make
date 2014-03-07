#!/bin/sh

# sata DOM的大小必须在这个范围内
echo "" >$TARGET_FILE

echo "Find target device..."


for dev in $(ls /dev/sd[a-z]); do
    name=$(basename $dev)
    size=$(cat /sys/block/$name/size)

    if [ "$?" != "0" ]; then
        continue
    fi
    if [ "$size" -lt $MIN_SIZE ]; then
        continue
    fi
    if [ "$size" -gt $MAX_SIZE ]; then
        continue
    fi
    echo "Using disk $dev as target device"
    echo $dev >$TARGET_FILE

    # check DOM
    if ! check_dom $dev; then
        break
    fi
    exit 0
done

echo "Can't find target device for install"
exit 1
