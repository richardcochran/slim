#!/usr/bin/gawk -f

BEGIN {
    FS = "\t"
}

{
    if ($5 != "Proprietary") {
	printf "%s\t%s\n",$1,$5;
    }
}
