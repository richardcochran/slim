#!/bin/bash

usage ()
{
	echo ""
	echo "usage: `basename $0` [ARGS]"
	echo ""
	echo "-a make a GNU autoconf package"
	echo "-d template directory"
	echo "-h shows this message"
	echo "-g use git"
	echo "-p package name"
	echo ""
}

body="body.mk"
git="no"

while getopts :ad:hgp: OPT; do
	case $OPT in
	a)
		body="ac-body.mk"
		;;
	d)
		dir="$OPTARG"
		;;
	g)
		git="yes"
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

if [ -z $dir ]; then
	usage
	exit 1
fi
if [ -z $pkg ]; then
	usage
	exit 1
fi

if [ $git = "yes" ]; then
	ver=master
	get=git
	url=git://git.${pkg}.org/${pkg}.git
	tgz="\$(PKG).tgz"
	src="\$(build)/\$(PKG)"
	distclean="rm -f \$(dld)/\$(TGZ)"
else
	ver=0.0.1
	get=wget
	url=http://${pkg}.org
	tgz="\$(PKG)-\$(VER).tgz"
	src="\$(build)/\$(PKG)-\$(VER)"
	distclean="true"
fi

sed	-e "s template $pkg g" \
	-e "s @VER@ $ver g" \
	-e "s @GET@ $get g" \
	-e "s @URL@ $url g" \
	-e "s @TGZ@ $tgz g" \
	-e "s @SRC@ $src g" \
	-e "s,@DISTCLEAN@,$distclean,g" \
	$dir/head.mk

cat $dir/$body

sed -e "s,@DISTCLEAN@,$distclean,g" $dir/tail.mk
