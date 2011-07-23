#!/usr/bin/perl
#use warnings;
while (<>) {
	s|/\*+[\s\S]+?\*/||g;	# delete /* multiline comments */
	s|\s*//.*$||g;				# delete to end of line // comments
	s/^\s+|\s+$//g;				# delete leading & trailing whitespace
	s/\s*([{}().,:;=?+-\/*@&%^])\s*/$1/g;	# delete spaces around {}().,:;=?+-/*@&%^
	s/<\?php([^\n])/<?php\n$1/g;	# insert break after "<?php"
	s/(function|class)/\r$1/g;	# insert break before "function" or "class"
	print $_;
}