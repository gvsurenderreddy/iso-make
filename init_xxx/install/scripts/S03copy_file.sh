#!/bin/sh

source functions.sh
source conf.sh

echo "Start copy files..."

dev=$(cat $TARGET_FILE)
if [ ! -b "$dev" ]; then
    echo "Disk $dev not found"
    exit 1;
fi

ROOT=$ROOT_DIR
OPT=$OPT_DIR
LOCAL=$LOCAL_DIR
tar_dir=$SOURCE/install

mkdir -p $ROOT
mkdir -p $OPT
mkdir -p $LOCAL

do_transfer()
{
    # $1: name, $2 dev, $3 dir, $4 tar
    name=$1
    part=$2
    dir=$3
    pkg=$4

    echo "Mount $name..."
    if ! mount $part $dir; then
        echo "Error: mount $name failed"
        exit 1
    fi

    tar  xf $pkg -C $dir
    if [ $? != 0 ] ;then
        echo "Error: $name files transforming failed!"
        exit 1
    fi
    if ! verify_pkg $dir; then
        echo "Error: $name files verify failed!"
        exit 1
    fi
    umount $dir
}

####
do_transfer "ROOT"  ${dev}1 $ROOT $tar_dir/root.tgz
do_transfer "OPT"  ${dev}5 $OPT $tar_dir/opt.tgz
do_transfer "LOCAL"  ${dev}1 $LOCAL $tar_dir/local.tgz

exit 0
