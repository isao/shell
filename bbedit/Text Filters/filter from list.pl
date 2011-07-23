#!/usr/bin/perl -w

# look for these words (or regexps)...
my @thesewords = ('mediabolic', '-client', '-gct', 'mtd', '.gz$');

LINE: while(<>) {
	foreach my $word (@thesewords) {
		next LINE if (!/$word/i);
	}
	print $_;	# print if all @thesewords are found in a line
}
