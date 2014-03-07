#!/bin/sh

source functions.sh
source conf.sh

echo "Start disk parted..."

dev=$(cat $TARGET_FILE)
if [ ! -b "$dev" ]; then
    echo "Disk $dev not found"
    exit 1;
fi

read_yes_no "Data on $dev will be lost"

if [ "$?" != "0" ]; then
    echo "Disk parted cancelled"
    # 需要确定此处是否可返回0
    exit 1
fi

dd if=/dev/zero of=$dev bs=1M count=1

fdisk $dev <<EOF
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
    part=$dev$part_no
    mkfs.ext4 $dev$part_no
    if [ $? != 0 ]; then
        echo "Error: Format $part failed"
        exit 1
    fi
done

exit 0
