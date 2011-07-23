#!/usr/bin/perl -w

while(<>) {
	s/( |\t)+$//;	# trim trailing spaces or tabs
	#s/^( |\t)+//;	# trim leading spaces or tabs
	print;
}
