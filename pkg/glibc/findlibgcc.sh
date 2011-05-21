#!/bin/bash

shopt -s nullglob
shopt -s extglob

path=`${CROSS_COMPILE}gcc -print-search-dirs | grep libraries | cut -d = -f 2`

path=${path//:/ }

for dir in $path; do
    libc=${dir}/libgcc_s.so.+([0-9])
    #echo path = $dir
    #echo libc = $libc
    if [ -z ${libc} ]; then
	#echo empty
	true
    else
	#echo not empty
	#ls $dir
	echo $dir
	exit 0
    fi
    #echo
done

exit 1
