#!/usr/bin/gawk -f

BEGIN {
    FS = "\t"
    printf "<html>"
    printf "<head>"
    printf "\n"
    printf "<link rel=\"stylesheet\" type=\"text/css\" href=\"pretty_manifest.css\" />"
    printf "\n"
    printf "<title>"
    printf "SLIM Manifest for " board
    printf "</title>"
    printf "\n"
    printf "</head>"
    printf "\n"
    printf "<body>"
    printf "<h1>"
    printf "SLIM Manifest for " board
    printf "</h1>"
    printf "\n"
    printf "<center>"
    printf "<table>"
    printf "\n"
    printf "<tr>"
    printf "<th>Package</th>"
    printf "<th>Method</th>"
    printf "<th>Version</th>"
    printf "<th>License Type</th>"
    printf "</tr>"
    printf "\n"
}

{
    class = NR % 2 ? "even" : "odd";
    printf "<tr class=\"" class "\">"
    gsub(strip,"");

    if ($7 != "-") {
	version = $7
    } else {
	version = $2
    }

    printf "<td>%s</td>",$1
    printf "<td>%s</td>",$3
    printf "<td>%s</td>",version
    printf "<td>%s</td>",$5

    printf "</tr>"
    printf "\n"
}

END {
    printf "</table>"
    printf "</center>"
    printf "</body>"
    printf "</html>"
    printf "\n"
}
