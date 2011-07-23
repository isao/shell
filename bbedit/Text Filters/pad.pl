#!/usr/bin/perl
use strict;
use warnings;

my %makemodel;
while (<>) {
	chomp;
	my ($make, $model) = split(/\t/);
	$makemodel{$make} .= "'$model',";
}
foreach my $key (keys %makemodel) {
	print "'$key':[".$makemodel{$key}."],\n";
}

__END__
input:

Acura	CL
Acura	Integra
Acura	Legend  
Acura	MDX 4x4
Acura	NSX
Acura	RL
Acura	RSX
Acura	SLX 4x4
Acura	TL
Acura	TSX
Acura	Vigor  
Audi	80
Audi	90
Audi	100
Audi	5000
Audi	100 AWD
Audi	90 AWD
...


output:

Acura:['CL','Integra','Legend','MDX 4x4','NSX','RL','RSX','SLX 4x4','TL','TSX','Vigor',],
Audi:['80','90','100','5000','100 AWD','90 AWD','A3','A4','A4 Quattro','A6','A6 Quattro','A8','A8 Quattro','allroad','allroad quatro','Cabriolet','Quattro','S4 Quattro','S6 Quattro','TT Quattro',],
...

(need to rm trailing comma from ,])
