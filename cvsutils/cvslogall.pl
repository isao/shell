#!/usr/bin/perl -w
# Copyright © 2005 Jamie Zawinski <jwz@jwz.org>
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation.  No representations are made about the suitability of this
# software for any purpose.  It is provided "as is" without express or 
# implied warranty.
#
# Run "cvs log" and "cvs diff" on each consecutive version of the file.
# That is, shows you every checkin, and its log message, in reverse order.
#
# Created: 16-Feb-2005.

require 5;
use diagnostics;
use strict;

my $progname = $0; $progname =~ s@.*/@@g;
my $version = q{ $Revision: 1.1 $ }; $version =~ s/^[^0-9]+([0-9.]+).*$/$1/;

my $verbose = 0;

my @cvs_args = ();

my @months = (undef,
              "Jan", "Feb", "Mar", "Apr", "May", "Jun",
              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

sub error {
  my ($err) = @_;
  print STDERR "$progname: $err\n";
  exit 1;
}

sub cvs_logall {
  my ($file) = @_;

  my @revs = ();
  my %logs = ();
  my %dates = ();
  my $body = `cvs log '$file'`;
  $body =~ s/^.*?\n---+\n//s;    # up to first line of ----
  $body =~ s/\n===+\n\s*$//s;    # trailing line of ====

  foreach (split (/\n---+\n/, $body)) {
    next unless m/^revision /;
    my ($rev, $date, $log) =
      m/^revision \s+ (\d+\.[\d.]+) \n
         date: \s+ ( .* ) \n
         ( .* ) $/sx;

    $date =~ s@^(\d\d\d\d)/(\d\d)/(\d\d)\b@$3-$months[$2]-$1@gs;

    push @revs, $rev;
    $logs{$rev} = $log;
    $dates{$rev} = $date;
  }

  for (my $i = 0; $i < $#revs; $i++) {
    my $r0 = $revs[$i+1];
    my $r1 = $revs[$i];
    print STDOUT ("#" x 79) . "\n";
    print STDOUT "revision: $r0 -> $r1\n";
    print STDOUT "date: $dates{$r1}\n";

    my $log = $logs{$r1};
    $log =~ s/^/    /gm;
    print STDOUT "\n$log\n\n";

    my @cmd = ("cvs", "diff", @cvs_args, "-r$r0", "-r$r1", $file);
    #print STDOUT "" . join(' ', @cmd) . "\n\n";
    system @cmd;
    print STDOUT "\n";
  }

}

sub usage {
  print STDERR "usage: $progname [--verbose] file ...\n";
  exit 1;
}

sub main {
  my @args = ();
  my @files = ();
  while ($#ARGV >= 0) {
    $_ = shift @ARGV;
    if ($_ eq "--verbose") { $verbose++; }
    elsif (m/^-v+$/) { $verbose += length($_)-1; }
    elsif (m/^-./) { push @args, $_; }
    else { push @files, $_; }
  }

  error ("no files specified") unless ($#files >= 0);

  @cvs_args = @args;
  foreach (@files) {
    cvs_logall ($_);
  }
}

main;
exit 0;
