#!/usr/bin/env perl
use strict;
use warnings;
$|=1;

#hash to map long cvs status to shorter ones for pretty columns 
my %status_map = (
	'Up-to-date'                  => ' ',
	'Locally Modified'            => 'modifi',
	'File had conflicts on merge' => 'confli',
	'Needs Patch'                 => 'patch',
	'Needs Merge'                 => 'merge',
	'Needs Checkout'              => 'checko');

open CVS_STATUS, 'cvs -q -d:ext:isao@etherwerks.com:/usr/home/isao/cvs status|';
while(<CVS_STATUS>) {

	if(/^File:\s+([^\t]+?)\s+Status:\s+(.+)$/) {
		print $status_map{$2} ? $status_map{$2} : $2;
		print "\t";
		
	}

	if(/Working revision:\s+([0-9.]+)/) {
		print $1;
	}
	
	if(/Repository revision:\s+([0-9.]+)\s+(.+),v/) {
		print "$1\t$2\t";
	}

	if(/Sticky Options:\s+(\S+)/) {
		print "$1\n";
	}

}