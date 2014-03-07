#!/bin/sh

source conf.sh
ISO_FILE=""

choose_iso()
{
    local dev_dir=$1
    local iso_file
    cd $dev_dir
    local iso_files=`ls ${ISO_PREFIX}*.iso 2>/dev/null`
    cd -
    local iso_file_cnt=`echo $iso_files | wc -w`
    if [ $iso_file_cnt -eq 0 ]; then
        return 1
    elif [ $iso_file_cnt -eq 1 ]; then
        ISO_FILE=$iso_files
        return 0
    fi

    while true
    do
        echo ""
        echo "Please choose iso file you want to install"
        echo "  0  Cancel the installation, reboot system"
        echo "$iso_files" | awk '{ print OFS OFS NR OFS OFS $0 }'
        read -p "input iso file No: " iso_file_no
        tmp=`expr $iso_file_no + 0 2>/dev/null`
        if [ -z "$iso_file_no" ] || [ "$tmp" != "$iso_file_no" ] || [ $iso_file_no -gt $iso_file_cnt -o $iso_file_no -lt 0 ]; then
            continue
        fi
        if [ $iso_file_no -eq 0 ]; then
            reboot
        fi

        iso_file=`echo $iso_files | cut -d ' ' -f $iso_file_no`
        read -p "Confirm install $iso_file, input 'YES' continue, else choose other iso file: " val
        if [ "x$val" = "xYES" ]; then
            ISO_FILE=$iso_file
            return 0
        fi
    done

    return 1
}

try_mount_iso()
{
    dev_dir=$1
    src_dir=$2
    choose_iso $dev_dir
    if [ ! -f $dev_dir/$ISO_FILE ]; then
        return 1
    fi
    mount $dev_dir/$ISO_FILE $src_dir -t iso9660 -o loop
    if [ "$?" != "0" ]; then
        return 1;
    fi
    return 0;
}

find_img()
{
    root_dir=$1
    if [ ! -d $root_dir/install ]; then
        return 1
    fi
    
    if [ ! -f $root_dir/install/root.tgz ]; then
        return 1
    fi

    if [ ! -f $root_dir/install/opt.tgz ]; then
        return 1
    fi

    if [ ! -f $root_dir/install/local.tgz ]; then
        return 1
    fi
    return 0
}

do_try_disk()
{
    # do_try_disk name fs
    name=$1
    fs=$2
    mount $name $ROOT_DEV -t $fs
    if [ "$?" != "0" ]; then
        return 1
    fi
    try_mount_iso $ROOT_DEV $SOURCE
    if [ "$?" != "0" ]; then
        umount $name
        return 1;
    fi

    find_img $SOURCE
    if [ "$?" != "0" ]; then
        umount $SOURCE
        umount $name
        return 1
    else
        return 0
    fi
}

try_disk()
{
    # try_disk name
    name=$1
    for i in ${name}[0-9]; do
        if [ -b $i ]; then
            for fs in vfat ext3 ext4; do
                do_try_disk $i $fs
                if [ "$?" = "0" ]; then
                    return 0
                fi
            done
        fi
    done
    return 1
}

echo "Find root image..."

mkdir -p $SOURCE
mkdir -p $ROOT_DEV

if [ -b /dev/sr0 ]; then
    mount /dev/sr0 /source -t iso9660
    if [ "$?" = "0" ]; then
        find_img /source
        if [ "$?" = "0" ]; then
            echo "Using CDROM(/dev/sr0) as source"
            return 0;
        fi
    fi
fi

for i in /dev/sd[a-z]; do
    sd=`basename $i`
    removable=`cat /sys/block/$sd/removable 2>/dev/null`
    if [ "$removable" = "0" ]; then
        continue
    fi
    echo "Searching disk $i"
    try_disk $i
    if [ "$?" = "0" ] ; then
        echo "Find iso in $i"
        echo "ISO mount to $SOURCE"
        exit 0;
    fi
done

echo "Can't find ISO for install"
exit 1
