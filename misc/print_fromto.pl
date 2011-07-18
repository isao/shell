#!/usr/bin/env perl
# Usage: print_fromto.pl <string1> <string2> file

my ($from, $to) = (shift, shift);
while (<>) {
  print if /$from/../$to/;
}

__END__

#my orig version till i discovered '..'
while (<>) {
	$start |= /$from/;
	print if ($start);
	exit if /$to/;
}

#1-liner cli version:
perl -ne 'print if /from/../to/;' file