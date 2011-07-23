#!/usr/bin/perl
use strict;
use warnings;

my $count = 0;
my $class = 'even';

while(<>) {
	$class = ($count % 2) ? 'odd' : 'even';
	$count++ if(s/<tr>/<tr class="$class">/);
	print;
}
