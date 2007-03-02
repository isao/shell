#!/usr/bin/perl -w
use Getopt::Long;

# CVS history viewer.
# http://www.neuro-tech.net/archives/000028.html
# Perl script to view a date-sorted history of a CVS repository.

my $sep = "--------------------------------------------------------";

my $user;
my $opts = GetOptions('user=s', \$user);

my @output = `cvs history -ac`;
my %actions = ( "M" => "committed", "A" => "added", "R" => "removed" );

my %developers;
my @bydate;

foreach(@output) {
	@fields = split;
	$full = "$fields[7]/$fields[6]";

	if(defined $user) {
		if($fields[4] ne $user) { next; }
	}

	my $act = $actions{$fields[0]};
	push @bydate, "$fields[1] $fields[2] $full - $fields[4] $act $fields[5]";

	# Commits by developer
	if(defined $developers{$fields[4]}) {
		$developers{$fields[4]} = $developers{$fields[4]} + 1;
	} else {
		$developers{$fields[4]} = 1;
	}
}

if(!defined $user) {
	print "\nCommits by developer\n$sep\n";
	foreach(keys %developers) {
		print "$_ - $developers{$_}\n";
	}
}

print "\nActions by Date\n$sep\n";
foreach(sort @bydate) {
	print "$_\n";
}
print "\n";

