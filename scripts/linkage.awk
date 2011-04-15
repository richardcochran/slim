#!/usr/bin/gawk -f

BEGIN {
    printf "<html>"
    printf "<head>"
    printf "\n"
    printf "<link rel=\"stylesheet\" type=\"text/css\" href=\"linkage.css\" />"
    printf "\n"
    printf "<title>"
    printf "OEL Linkage Report for " board
    printf "</title>"
    printf "\n"
    printf "</head>"
    printf "\n"
    printf "<body>"
    printf "<h1>"
    printf "OEL Linkage Report for " board
    printf "</h1>"
    printf "\n"
    printf "<center>"
    printf "\n"
    printf "<table>"
    printf "\n"
    printf "<tr>"
    printf "<th colspan=2>Binary</th>"
    printf "<th>Library</th>"
    printf "<th>Package</th>"
    printf "<th>License</th>"
    printf "</tr>"
    printf "\n"
}

$3=="BINARIES" {
    if ($2 == "Proprietary") {
	for (i = 4; i <= NF; i++) {
	    binaries[$i] = 1;
	    package[$i] = $1;
	}
    }
}

$2=="LINKS" {
    libraries = "";
    for (i = 3; i <= NF; i++) {
	split($i, tmp, ".");
	libraries = libraries " " tmp[1];
    }
    links[$1] = libraries;
}

$3=="PROVIDES" {
    for (i = 4; i <= NF; i++) {
	license[$i] = $2;
	provider[$i] = $1;
    }
}

END {
    i = 0;
    for (bin in binaries) {
	list[i++] = bin;
    }
    len = asort(list);
    for (i = 1; i <= len; i++) {
	bin = list[i];
	printf "<tr class=\"even\">"
	printf "<td>%s</td><td>[%s]</td>", bin, package[bin];
	printf "<td></td><td></td><td></td>"
	printf "</tr>"
	printf "\n"
	split(links[bin], tmp);
	for (t in tmp) {
	    lib = tmp[t];
	    printf "<tr class=\"odd\">"
	    printf "<td></td><td></td>"
	    printf "<td>"
	    printf "%s", lib;
	    printf "</td>"
	    printf "<td>"
	    printf "%s", provider[lib];
	    printf "</td>"
	    printf "<td>"
	    printf "%s", license[lib];
	    printf "</td>"
	    printf "</tr>"
	    printf "\n"
	}
    }
    printf "</table>"
    printf "</center>"
    printf "</body>"
    printf "</html>"
    printf "\n"
}
