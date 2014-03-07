#!/bin/sh

echo "Start installing GRUB"

export PATH=/x86/bin:/x86/sbin:${PATH}

dev=$(cat $TARGET_FILE)
if [ ! -b "$dev" ]; then
    echo "Disk $dev not found"
    exit 1;
fi

mkdir -p /tmp/root
mount ${dev}1 /tmp/root >/dev/null 2>71
grub-install --root-directory=/tmp/root ${dev}
if [ $? != "0" ]; then
    echo "Error: GRUB install failed"
    exit 1;
fi

exit 0

