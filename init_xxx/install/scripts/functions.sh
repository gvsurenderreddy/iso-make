#!/bin/sh

read_yes_no()
{
    msg=$1
    query=unknown
    while [ "x$query" != "xYES" ] && [ "x$query" != "xNO" ] && [ "x$query" != "xDEBUG" ]; do
        echo "Type 'YES' or 'NO'"
        read -p "$msg [YES/NO]: " query
    done
    if [ "x$query" = "xYES" ]; then
        return 0
    elif [ "x$query" = "xDEBUG" ]; then
        return 1
    else
        reboot
    fi
}

clean_software()
{
    disks=`ls /sys/block | grep sd`
    for disk in $disks
    do
        if ls -l /sys/block/$disk | grep -q "/usb"; then
            continue
        fi
        
        echo "clean /dev/$disk ..."
        for i in `seq 0 7`
        do
            seek=$((1000*$i))
            dd if=/dev/zero of=/dev/$disk bs=1M count=100 seek=$seek 2>/dev/null
        done
    done
}
