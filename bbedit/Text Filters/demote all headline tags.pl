#!/usr/bin/perl
use strict;
use warnings;

while(<>) {
	if(m~(</?h)(\d+)~) {
		my $h = 1 + $2;
		s/(<\/?h)(\d+)/$1$h/g;
	}
	print;
}
