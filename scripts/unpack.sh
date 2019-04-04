#!/bin/bash

usage ()
{
    echo ""
    echo "usage: `basename $0` [ARGS]"
    echo ""
    echo "-d name   destination directory"
    echo "-f name   source tar file"
    echo "-s name   source directory (default \$dld)"
    echo ""
}

srcdir=$dld

while getopts :d:f:hs: OPT; do
    case $OPT in
	d)
	    destdir="$OPTARG"
	    ;;
	f)
	    file="$OPTARG"
	    ;;
	s)
	    srcdir="$OPTARG"
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

if [ -z "$destdir" ]; then
    echo "Need a destination directory."
    usage
    exit 1
fi

if [ -z "$file" ]; then
    echo "Need a file name."
    usage
    exit 1
fi

if [ -z "$srcdir" ]; then
    echo "Need a source directory."
    usage
    exit 1
fi

cd "$destdir"

tar --touch -xf "$srcdir"/"$file"

[ ! -e "$srcdir"/upstream_"$file" ] && exit 0

tar -xf "$srcdir"/upstream_"$file"

original=`basename upstream_"$file" .tgz`
derived=`basename "$file" .tgz`

diff -u -N --recursive "$original" "$derived" | gzip > \
    "$srcdir"/"$derived".diff.gz

rm -Rf "$original"

exit 0
