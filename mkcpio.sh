#!/bin/sh

back_dir=init_xxx
rm $back_dir -rf
cp -a init $back_dir

cd $back_dir
if [ $? != "0" ]; then
    echo "Can find $back_dir"
    exit 1
fi
find . -name ".git" -exec rm -rf {} \; 2>/dev/null
find . | cpio --quiet -H newc -o | gzip -n > ../initrd.gz
cd ..
#mount /dev/loop0p1 /media/usb0
#cp initrd.gz /media/usb0/boot
#umount /dev/loop0p1
