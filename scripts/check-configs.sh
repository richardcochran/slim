#!/bin/bash

fulldiff=no

usage ()
{
	echo ""
	echo "usage: `basename $0` [ARGS]"
	echo ""
	echo "-d show full diff"
	echo "-h shows this message"
	echo ""
}

check ()
{
	old=$1
	new=$2

	[ ! -f $old ] && return
	[ ! -f $new ] && return

	if [ $fulldiff = yes ]; then
		arg=-u
	else
		arg=--brief
	fi
	diff $arg $old $new
	if [ $? = 1 -a $fulldiff = no ]; then
		printf "Store changes in working copy with:\n"
		printf "\n\tcp $new $old\n\n"
	fi
}

while getopts :dh: OPT; do
	case $OPT in
	d)
		fulldiff=yes
		;;
	h)
		usage
		exit 0
		;;
	*)
		usage
		exit 1
	esac
done

if [ -f config/${BOARD}/Config.busybox ]; then
	check config/${BOARD}/Config.busybox ${BOARD}/build/busybox/.config
else
	check pkg/busybox/Config ${BOARD}/build/busybox/.config
fi
check config/${BOARD}/Config.ipipe   ${BOARD}/build/ipipe/.config
check config/${BOARD}/Config.linux   ${BOARD}/build/linux/.config
check config/${BOARD}/slim_config    .config.${BOARD}
