#!/usr/bin/perl -w
#find all strings matching a regex, and print them to STDERR with their 
#frequency counts

#uncomment for: php vars
#my $regex = '(\$[a-z0-9_-]+)';

#uncomment for: includes
#my $regex = '\b((?:require|require_once|include|include_once)\b.+$)';

#uncomment for: smacs placeholders
#my $regex = '(\{.+?\})';

#my $regex = '^((?:warning|notice|fatal).+)$';

#my $regex = 'name="([^"]+)"';

#my $regex = '(?=function )([^\(]+)';

my $regex = '\{\{([^}]+)\}\}';

my @found;

while(<>) {
	if(m/$regex/i) {
		print STDERR "$1\n";
		#$found{$1}++ if(/($regex)/i);
	}
}

__END__
#sorted keys
my @sort = sort {uc($a) cmp uc($b)} keys(%found);


foreach (@sort) {
	#print STDERR "$found{$_}\t$_\n";
	print STDERR "$_\n";
}
