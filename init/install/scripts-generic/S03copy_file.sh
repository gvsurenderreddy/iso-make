#!/bin/sh

source functions.sh
source conf.sh

dev=$(cat $TARGET_FILE)
if [ ! -b "$dev" ]; then
    echo "Disk $dev not found"
    exit 1;
fi

do_transfer()
{
    # $1: pkg, $2 dir
    pkg=$1
    dir=$2

    echo "Install `basename $dir` ..."

    tar  xf $pkg -C $dir
    if [ $? != 0 ] ;then
        echo "Error: `basename $dir` install failed!"
        exit 1
    fi
}

parts=`ls $SOURCE/install/*.tgz`
for part in $parts
do
	mount_dir=`basename $part | awk -F '_' '{ print $2 }'`
	do_transfer $part /tmp/$mount_dir
done

exit 0
