#!/usr/bin/gawk -f

BEGIN {
	FS = "\t"
}

{
	if      ($5 == "CCPL")  list = 1;
	else if ($5 == "BSD")   list = 1;
	else if ($5 == "GPL")   list = 1;
	else if ($5 == "GPL2")  list = 1;
	else if ($5 == "GPL3")  list = 1;
	else if ($5 == "INTEL") list = 1;
	else if ($5 == "LGPL")  list = 1;
	else if ($5 == "LGPL2") list = 1;
	else if ($5 == "LGPL3") list = 1;
	else if ($5 == "MIT")   list = 1;
	else list = 0;
	if (list) {
		nf = split($6,tmp,"/");
		file = tmp[nf];
		printf "%s\t%s\t%s/%s\n", $1, $5, $1, file
	}
}
