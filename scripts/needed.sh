#!/bin/sh

# This script requires the environment to set:
# rootfs
# CROSS_COMPILE

for bin in $*; do
    path=`find ${rootfs} -type f -name $bin` ;
    lib=`${CROSS_COMPILE}objdump -x $path | grep NEEDED` ;
    lib=`echo $lib | sed -e 's/NEEDED//g'` ;
    echo $bin LINKS $lib ;
done
