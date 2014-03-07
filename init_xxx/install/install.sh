#!/bin/sh

INSTALL_ROOT=/install
cd $INSTALL_ROOT

source scripts/conf.sh
source scripts/functions.sh
udevd -d

echo "Waiting for device initializing..."
sleep 5

# make sure we has ext4 module loaded
modprobe ext4
#read_yes_no "Start Installation"
while true
do
    echo ""
    echo " 0 Cancel installation, reboot system"
    echo " 1 Start installation"
    echo " 2 Clean software"
    read -p "Enter the operation number: " op_no
    if [ "x$op_no" = "x0" -o "x$op_no" = "x1" -o "x$op_no" = "x2" -o "x$op_no" = "xDEBUG" ]; then
        break
    fi
done

if [ "x$op_no" = "x0" ]; then
    echo "Installation cancelled, reboot"
    reboot
    sleep 30
elif [ "x$op_no" = "xDEBUG" ]; then
    echo "Installation cancelled"
    exec /bin/sh
elif [ "x$op_no" = "x2" ]; then
    clean_software
    poweroff
    sleep 30
fi

if [ "x$op_no" != "x1" ]; then
    echo "unkown error, reboot"
    reboot
fi
for script in $(ls ./scripts/S[0-9][0-9]*); do
    RET=0
    echo "Exec script $script"
    if [ -x $script ] ; then
        prog=$(basename $script)
        cd scripts && ./$prog
        if [ "$?" != "0" ]; then
            echo "Install failed: $script"
            RET=1
            break;
        fi
        cd ..
    fi
done

if [ $RET != "0" ]; then
    echo "Failed to install"
    exec /bin/sh
fi

sleep 2
read -t 3 -p "Unplug USB disk. Press Enter to Reboot:" query
reboot

