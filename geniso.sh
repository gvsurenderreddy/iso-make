#!/usr/bin/env bash

file_check()
{
	file="$1"
	[ ! -f "$file" ] && echo "file $file not exist!" && exit -1
}

usage()
{
	sys_type=`ls package 2>/dev/null`
	echo ""
	echo "geniso.sh `echo $sys_type | tr ' ' '|'` <version>"
	echo ""
	exit 1
}

[ "$1" = "" ] || [ "$2" = "" ] && usage && exit 1

arch="$1"
version="$2"
if [ ! -d "package/$arch" ]; then
	echo "Please enter the correct type of system."
	usage
	exit 1
fi

echo "using $arch"

mv -f package/$arch/*.tgz iso-c/install/

file_check "iso-c/install/root.tgz"
file_check "iso-c/install/local.tgz"
file_check "iso-c/install/opt.tgz"

cp initrd.gz iso-c/
genisoimage -o jw-linux-${version}-${arch}.iso \
   -b isolinux/isolinux.bin -c isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
    iso-c

mv -f iso-c/install/*.tgz package/$arch
