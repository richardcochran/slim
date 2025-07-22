#!/bin/bash

shopt -s nullglob

path=`${CROSS_COMPILE}gcc -print-search-dirs`

path=${path//:/ }

for dir in $path; do
	if [ -d ${dir}../../sources ]; then
		realpath $dir../../sources
		#echo FOUND
		#ls -lh ${dir}../../sources
		exit 0
	fi
done

exit 1
