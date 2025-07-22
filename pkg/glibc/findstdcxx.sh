#!/bin/bash

shopt -s nullglob
shopt -s extglob

#
# First, try and use -print-sysroot if available.
#

sysroot=`${CROSS_COMPILE}gcc -print-sysroot 2>/dev/null`
code=$?

if [ $code = 0 ]; then
	if [ "x$sysroot" != "x" ]; then
		realpath $sysroot/lib
		exit 0
	fi
fi

path=`${CROSS_COMPILE}gcc -print-search-dirs | grep libraries | cut -d = -f 2`

path=${path//:/ }

for dir in $path; do
	libcxx=${dir}/libstdc++.so.+([0-9])
	#echo path = $dir
	#echo libcxx = $libcxx
	if [ -z ${libcxx} ]; then
		#echo empty
		true
	else
		#echo not empty
		#ls $dir
		realpath $dir
		exit 0
	fi
	#echo
done

exit 1
