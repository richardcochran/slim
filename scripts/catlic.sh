#!/bin/bash

usage ()
{
    echo ""
    echo "usage: `basename $0` [ARGS]"
    echo ""
    echo "-d destination directory"
    echo "-f license file"
    echo "-h shows this message"
    echo "-l license list (append license file onto this)"
    echo "-p package name"
    echo ""
}

while getopts :d:f:hl:p: OPT; do
    case $OPT in
	d)
	    destdir="$OPTARG"
	    ;;
	f)
	    file="$OPTARG"
	    ;;
	l)
	    liclist="$OPTARG"
	    ;;
	p)
	    pkg="$OPTARG"
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

HR="==========================================================================="

if [ -f "$file" ]; then
    echo $HR	>> "$destdir/$liclist"
    echo "License Notification for the '$pkg' Package" >> "$destdir/$liclist"
    echo $HR	>> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
    cat "$file" | sed s/"\r"// | sed s/"\f"// >> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
fi

exit 0
