#!/usr/bin/perl
use strict;
use warnings;

my (%h, $c);
while(<>) {
	$c = scalar(split(',', $_));
	#%h{$c}++;
	print "$c\n";
}



__END__
my $aa = 2;
my $re = '^[125]$';

if ($aa =~ qr/$re/) {
#if ($aa =~ m/^[125]$/) {
	print "passes\n";
} else {
	print "fails\n";
}

my $in = 'error1';

$in =~ m/(error\d+|subscribe\.ok\d+)/ig;

print "$1\n";