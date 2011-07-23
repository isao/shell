#!/usr/bin/perl -w

my $i = 0;

while(<>)
{
	$i++;
	print sprintf("%4d: ",$i), $_;
}
