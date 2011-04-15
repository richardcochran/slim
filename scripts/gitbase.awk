#!/usr/bin/gawk -f

{
    if ($1 == "VER" && $2 == "=") {
	printf "VER = %s\n",sha1sum
    } else {
	print $0
    }
}
