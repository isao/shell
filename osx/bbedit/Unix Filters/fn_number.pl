#!/usr/bin/perl
use warnings;
my $i = 0x00; #hex number
while(<>) {
	if (m/^(\s+")(.*",)\s*$/) {
		printf "%s%03x %s\n", $1, $i++, $2 ;
	} else {
		print $_;
	}
}
