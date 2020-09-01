#!/usr/bin/gawk -f
#
# Finds the variables in an autconf config.cache that have two
# different values.  You might think autoconf scripts always produce
# the same results, but you would be wrong.

BEGIN {
	FS = "=";
}

{
	word = $1;
	if (word == last) {
		printf "%d DUP %s\n", NR, $0;
	}
	last = word;
}
