#!/usr/bin/perl -w

# List:	BBEdit-Talk
# Date:	11/06/2001 @ 16:39:40
# From:	gruber@barebones.com (John Gruber)
# Subject:	Re: word count filter

use strict;

my %count;

sub by_count
{
    ( $count{$b} <=> $count{$a} ) || ( $a cmp $b )
}

while (<>) {
  for my $word (split) {
    next unless $word =~ /\w/;
    $word =~ s/^\W+//;
    $word =~ s/\W+$//;
    $count{lc $word}++;
  }
}

my @sortedwords = sort by_count keys( %count );

foreach (@sortedwords) {
    print "$count{$_}\t$_\n";
}

__END__