#!/usr/bin/perl

#
# CSS Syntax Check.pl
# Command-line screenscraper for the W3C's CSS Validator.
#
# Copyright (c) 2005 John Gruber
# <http://daringfireball.net/projects/csschecker/>  
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#

use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '1.0.0';
# Sat 03 Sep 2005

use HTML::Entities;


my $VALIDATOR_URL = 'http://jigsaw.w3.org/css-validator/validator';
my $PATH = $ARGV[0];

# We really ought to use LWP for this, but shelling out to `curl`
# makes life easier for most users because LWP doesn't ship as
# part of the standard Perl library.
my $result_html = qx(curl --silent -F "file=\@$PATH" $VALIDATOR_URL);

# Lame error checking:
if ($result_html !~ m{<html}xms) {
	die "Couldn't get syntax check results from W3C.";
}

my $output = '';

# First, check for errors:
if ($result_html =~ m{<div id="errors">(.+?)</div>\s*</div>}s) {
	my $error_html = $1;
	my @errors = $error_html =~ m{<li>.+?</li>}msg;
	foreach my $error (@errors) {
		my ($line_num) = $error =~ m{Line[ ]?: (\d+)}ms;
		my ($error_msg) = $error =~ m{<p>(.+)</p>}s;

		# Clean up HTML in the error description
		$error_msg =~ s{\n}{}g;
		$error_msg =~ s{<.+?>}{}g;
		decode_entities($error_msg);
	
		$output .= "Error: $line_num:\t$error_msg\n";
	}
}

# Then check for warnings:
if ($result_html =~ m{<div id="warnings">(.+)}ms) {
	my $warning_html = $1;
	my @warnings = $warning_html =~ m{<li><span class='warning'>.+?</li>}msg;
	foreach my $warning (@warnings) {
		my ($line_num) = $warning =~ m{<li><span class='warning'>Line[ ]?: (\d+)}ms;
		my ($warning_msg) = $warning =~ m{</span>(.+)}ms;

		# Cleanup html in the warning description
		$warning_msg =~ s{\n}{}g;
		$warning_msg =~ s{<.+?>}{}g;
		decode_entities($warning_msg);

		$output .= "Warning: $line_num:\t$warning_msg\n";
	}
}

# If there are no errors or warnings, say so:
$output =~ s{\A\s*\z}{No syntax errors detected.\n};
print $output;



__END__

