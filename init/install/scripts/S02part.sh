#!/bin/sh

source functions.sh
source conf.sh

dev=$(cat $TARGET_FILE)
if [ ! -b "$dev" ]; then
    echo "Disk $dev not found"
    exit 1;
fi

echo "Part $dev ..."
dd if=/dev/zero of=$dev bs=1M count=1 >/dev/null 2>&1

fdisk $dev >/dev/null 2>&1 <<EOF
o
n
p
1

+${ROOT_SIZE}
n
e
2


n
l

+${OPT_SIZE}
n
l

+${LOCAL_SIZE}
n
l


w
EOF

mdev -s

mkdir -p /tmp/root
mkdir -p /tmp/opt
mkdir -p /tmp/local

for part_no in 1 5 6 7; do
    part_dev=$dev$part_no
    echo "Format $part_dev ..."
    mkfs.ext4 $part_dev >/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "Error: Format $part_dev failed"
        exit 1
    fi
done

exit 0
