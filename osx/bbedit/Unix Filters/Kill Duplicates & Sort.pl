#!/usr/bin/perl -w

use strict;

my %seen;
while (<>) {
    $seen{$_}++;
}

print sort keys %seen;