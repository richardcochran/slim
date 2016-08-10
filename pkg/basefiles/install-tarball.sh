#!/bin/sh
#
# Installs a root file system from a tar file onto a given partition.
#

set -e
tgz=$1
dev=$2
old=`pwd`

if [ -z "$tgz" -o -z "$dev" ]; then
	echo Need two arguments: tar file and device name.
	exit 1
fi
if [ ! -f $tgz ]; then
	echo file $ifs does not exist!
	exit 1
fi
if [ ! -b $dev ]; then
	echo device $dev does not exist!
	exit 1
fi

set -x
mount $dev /mnt
cd /mnt
tar xzf $tgz
cd $old

mount -o bind /sys /mnt/sys
chroot /mnt /sbin/mdev -s
umount /mnt/sys
umount /mnt
