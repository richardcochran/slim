#!/bin/bash

usage ()
{
    echo ""
    echo "usage: `basename $0` [ARGS]"
    echo ""
    echo "-d destination directory"
    echo "-f input file"
    echo "-h shows this message"
    echo "-n number"
    echo ""
}

number=900

while getopts :d:f:hn: OPT; do
    case $OPT in
	d)
	    destdir="$OPTARG"
	    ;;
	f)
	    file="$OPTARG"
	    ;;
	n)
	    number="$OPTARG"
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
shift `expr $OPTIND - 1`
OPTIND=1

if [ -f "$file" ]; then
    mkdir -p "$destdir"
    cp "$file" "$destdir/startup-$number-$file"
fi

exit 0

