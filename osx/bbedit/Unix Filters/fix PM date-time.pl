#! /usr/bin/perl -w

use strict;

while (<>) {

	chomp;

	my @val = split (/\t/, $_, 10000);	# split, preserving all fields

	for my $i (0 .. @val - 1)
	{
		my $val = $val[$i];
		# look for strings in MM-DD-[CC]YY format
		next unless $val =~ /^(\d{1,2})\D(\d{1,2})\D(\d{4}) (\d{1,2}):(\d{2}) (am|pm)$/;
		my ($month, $day, $year, $hh, $mm, $ampm) = ($1, $2, $3, $4, $5, $6);
		$hh += $ampm eq "pm" ? 12 : 0;
		$hh = $hh == 24 ? 0 : $hh;
		$val[$i] = sprintf ("%02d-%02d-%02d %02d:%02d:00", $month, $day, $year, $hh, $mm);
	}
	print join ("\t", @val) . "\n";
}

exit (0);
