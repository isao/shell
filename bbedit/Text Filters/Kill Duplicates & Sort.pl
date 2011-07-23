#!/usr/bin/perl -w

use strict;

my %seen;
while (<>) {
	chomp;
    $seen{$_}++;
}

foreach (sort keys %seen) {
	print $_, "\n";
}