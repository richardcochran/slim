#!/bin/bash
#
# Create genromfs /dev files from a genext2fs device table.
#
# Copyright (C) 2011 Richard Cochran <richardcochran@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

usage ()
{
	printf "\n"
	printf "usage: `basename $0` romfs_root_dir device_table\n"
	printf "\n"
}

if [ -z "$1" -o -z "$2" ]; then
	usage
	exit 1
fi

while read filename type mode uid gid major minor start inc count ; do

	hash=${filename:0:1}
	base=`basename $filename`
	dir=`dirname $filename`

	if [ "$hash" == "#" ]; then
		continue
	fi
	if [ x$type == "xd" ]; then
		mkdir -p $1$filename
		continue
	fi
	if [ x$type != "xc" -a x$type != "xb" ]; then
		continue
	fi

	if [ x$start == "x-" -a x$inc == "x-" -a x$count == "x-" ]; then
		touch "$1$dir/@$base,$type,$major,$minor"
		chmod $mode "$1$dir/@$base,$type,$major,$minor"
		continue
	fi

	for cnt in `seq $count`; do
		touch "$1$dir/@$base$start,$type,$major,$minor"
		chmod $mode "$1$dir/@$base$start,$type,$major,$minor"
		start=$((start + inc))
		minor=$((minor + inc))
	done

done <$2
