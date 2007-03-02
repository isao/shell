#!/usr/bin/env perl
# Usage: print_fromto.pl <string1> <string2> file
my ($from, $to) = (shift, shift);
while (<>) {
  $start |= /$from/;
  print if ($start);
  exit if /$to/;
}
