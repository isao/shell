#!/usr/bin/env perl
my $sel = '', @parts;

while(<>) {
	chomp;#rm trailing line break, whitespace
	s/\s+/', '/g;#change tab to quote-comma-quote
	s/(^|$)/'/g;#enclose line in quotes
	print;
	print "\n";
}

__END__
for input:

Acura	CL
Acura	Integra
Audi	100 AWD
Audi	90 AWD

output is:

'Acura', 'CL'
'Acura', 'Integra'
'Audi', '100 AWD'
'Audi', '90 AWD'

