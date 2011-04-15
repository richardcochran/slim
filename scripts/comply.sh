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
    echo "-s source tar file name"
    echo "-t license type"
    echo ""
}

while getopts :d:f:hl:p:s:t: OPT; do
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
	s)
	    source="$OPTARG"
	    ;;
	t)
	    type="$OPTARG"
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
    mkdir -p "$destdir/$pkg"
    cp "$file" "$destdir/$pkg"
    echo $HR	>> "$destdir/$liclist"
    echo "License Notification for the '$pkg' Package" >> "$destdir/$liclist"
    echo $HR	>> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
    cat "$file" | sed s/"\r"// | sed s/"\f"// >> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
    echo ""     >> "$destdir/$liclist"
fi

if [ -f "$source" ]; then

    case "$type" in
	GPL|GPL2|GPL3|LGPL|LGPL2|LGPL3)
	    mkdir -p "$destdir/src"

	    basename=`basename $source .tgz`
	    dirname=`dirname $source`
	    patch="$dirname"/"$basename".diff.gz
	    upstream="$dirname"/upstream_"$basename".tgz

	    if [ -f "$patch" ]; then
		cp "$upstream" "$patch" "$destdir/src"
	    else
		cp "$source" "$destdir/src"
	    fi
	    ;;
	*)
	    ;;
    esac

fi

exit 0

