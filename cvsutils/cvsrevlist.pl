#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long qw(:config pass_through);
$|=1;

#are we in a cvs sandbox?
cvs_check();

#option defaults
my @tags = ();
my $filter = 0;
my $quiet = 0;
my $cvsop = '';

#process comand line options
GetOptions(
	't|tag=s'        => \@tags,       #tags to check revisions for
	'f|filterdiffs'  => \$filter,     #flag for showing only diff items
	'q|quiet'        => \$quiet,      #supress header, notices
	'c|cvsopts=s'    => \$cvsop);     #passthru options for `cvs` command
@tags = tag_legality_check(@tags);  #filter out illegal tagnames
my $cvs_stat_ops = join ' ', @ARGV; #passthru unknown options to `cvs status`

#config
my @rows = (@tags, 'HEAD', 'file'); #column order and hash key init
my $no_rev = 'n/a';                 #string to display if no revision exists

#init working vars
my %row = ();                       #hash to accumulate tag revs & file for each row
my %tally = init_row(0);            #count missing revisions for tags in hash
my $filecount = 0;                  #count of files found
my @missing = ();                   #accumulate files not in cvs
my @added = ();                     #locally added files

#regexes of cvs status output lines
my $base_re = '^\s+Repository revision:\s+([0-9.]+)\s+/home/cvsroot/(.+),v$';
my $newf_re = '^File: (.+)\s+Status: Locally Added$';
my $tags_re = '^\t('.(join '|', @tags).') +\t\(revision: ([0-9.]+)\)$';

#parse output of cvs status -v into tab-delimited lines
open CVS_STATUS_V, "cvs -q $cvsop status -v $cvs_stat_ops|";
while(<CVS_STATUS_V>) {

	if(m/$base_re/) {           #matching file and head revision
		$row{'HEAD'} = $1;
		$row{'file'} = $2;
		$filecount++;

	} elsif(m/$tags_re/) {      #matching cvs tag
		$row{$1} = $2;

	} elsif(m/^={66,}$/) {      #start of a multi-line cvs status output
		scalar %row               #if row data is not empty
			? print_row(%row)       #then we have data, so print row
			: print_hed(@rows);     #otherwise it must be 1st loop, print header
		%row = init_row($no_rev); #(re)init row hash

	} elsif(m/$newf_re/) {      #locally added file
		$row{'file'} = $1;
		push @added, $1;

	} elsif(m/^\? (.+)$/) {     #file not in cvs
		push @missing, $1;

	}
}
close CVS_STATUS_V;
print_row(%row) if(scalar %row);#last/only row
print_notice('locally added file', @added);
print_notice('not in cvs', @missing);
print_tally($filecount, %tally);
exit;


#make keys for row hash
sub init_row
{
	my $val = shift;
	my %r;
	foreach my $c (@rows) {
		$r{$c} = $val;
	}
	return %r;
}

#print header as a tab-delimited row of hash keys
sub print_hed
{
	print ((join "\t", @_)."\n") unless($quiet);
}

#print tab-delimited row data
#use @rows to enforce the hash key order
#tally counts of missing revisions
#append a ! if revision 2 exists and is different than revision 1
sub print_row
{
	my %r = @_;
	my @out;
	foreach my $k (@rows) {
		push @out, $r{$k};
		$tally{$k}++ if($r{$k} eq $no_rev); #tally missing revisions
	}
	if((scalar @tags) and diff($out[0], $out[1])) {
		$out[1] = $out[1].'*';    #add asterisk to col2 if different than col 1
	} elsif($filter) {
		return;                   #don't print non-different rows if filter on
	}
	print ((join "\t", @out)."\n");
}

# does 2nd tag exists, and is different than the 1st tag's revision?
# tag1 revision is column 1
# tag2 revision is column 2
sub diff
{
	return (($_[0] ne $_[1]) and ($_[1] ne $no_rev));
}

#print array to STDERR w/a msg
sub print_notice
{
	return unless((scalar @_ > 1) and !$quiet);
	my $msg = shift;
	foreach my $k (@_) {
		print STDERR "notice: $msg --> $k\n";
	}
}

#print hash of missing revisions
sub print_tally
{
	return unless((scalar @_ > 1) and !$quiet);
	my ($filecount, %tally) = @_;
	foreach my $k (keys %tally) {
		if($tally{$k}) {
			print STDERR "notice: no revision '$k' on $tally{$k}/$filecount files\n";
		}
	}
}

#look for CVS/Entries
sub cvs_check
{
	if(!-r 'CVS/Entries') {
		die "error: this script should be run from within a sandbox.\n`perldoc $0` for more info.\n";
	}
}

#add any legal cvs tagnames passed as command line arguments to the list of tag
#revisions to compile and list
sub tag_legality_check
{
	my @tags;
	foreach my $k (@_) {
		if($k =~ m/^[a-zA-Z0-9_-]+$/) {
			push @tags, ($k);
		} else {
			print STDERR "error: ignoring illegal tagname '$k'\n";
		}
	}
	return @tags;
}

__END__
=pod

=head1 NAME

cvsrevlist.pl - list revisions of every configured tagname by file

=head1 SYNOPSIS

cvsrevlist.pl [--tag <tag> [--tag <tag>...] [--filter] [--quiet] [--cvsopts "<opts>"] [[-vlR] [<file/dir>]]

cvsrevlist.pl [-t <tag> [-t <tag>]...] [-c "<opts>"] [-fqvlR <file/dir>]

=head1 SUMMARY

This script summarizes the output of `cvs status` into tabular form. Run this script in a local cvs repository-- anywhere you can run `cvs status`.

Run without any optons, the script sends a tab separated list of cvs head revision numbers and filepaths for the files in the current cvs directory. For example:

  % cvsrevlist.pl
  HEAD    file
  1.6     catools/cvs_tag_fu/cvsrevlist.pl
  1.1     catools/cvs_tag_fu/readme.txt

Additional tags can be specified see below.

=head1 OPTIONS

=over

=item -t, --tag <tagname1>

Specify a cvs tagname. Use multiple times for more tags. The corresponding revision number of each tagname will be sent to STDOUT in tab delimited columns in the order supplied. For example:

  % cvsrevlist.pl --tag QA --tag LIVE
  QA      LIVE    HEAD    file
  1.2     1.1     1.6     catools/cvs_tag_fu/cvsrevlist.pl
  1.1     1.1     1.1     catools/cvs_tag_fu/readme.txt

If a tag does not exist on a file, "n/a" is shown in place of it's revision number.

=item -f, --filter

Filter out files where the first two tag revisions are the same. Only show files where the second column's revision is different than the first's. Only applies when at least one tagname is supplied.

=item -q, --quiet

Supresses output of the header and all notices.

=item -v, -l, -R, and all other arguments...

All other argument(s) are passed thru to the `cvs status` command that cvsrevlist.pl calls internally. 

  Usage: cvs status [-vlR] [files...]
    -v      Verbose format; includes tag information for the file
    -l      Process this directory only (not recursive).
    -R      Process directories recursively.

For example: `cvsrevlist.pl -l error.html confirm.html` makes a cvs status call in the local directory only, not recursively, and only for files error.html and confirm.html.

=item -c, --cvsopts "<pass-thru options>"

Passes a quoted string as argument(s) to the `cvs` command that cvsrevlist.pl calls internally.

For example: `cvsrevlist.pl --cvsopts '-Z3 -d:pserver:iyagi@cvs:/home/cvsroot'` causes cvsrelist.pl to run `cvs -Z3 -d:pserver:iyagi@cvs:/home/cvsroot status` (gzip compression level 3, specifies $CVSROOT).

=head1 NOTICES, TALLIES, DIFFERENCE INDICATOR

Errors and notices are sent to STDERR. They include:

=over

=item difference indicator * (appears after a tag revision)

An indicator meaning the second tag's revision is different from the first's.

=item "notice: no revision '<tagname>' on <missing tally>/<total> files

If a tagname is supplied, a tally is kept of files who do not contain the tag. Files that do not contain a tag show "n/a" in that tag's column.
  
=item "locally added file --> <filename>"

A file has been locally added to the repository, but has not yet been committed. Locally added files do not obtain a revision number until they are committed.

=item "notice: not in cvs --> <filepath>"

No revision information exists for a file.

=back

=head1 EXAMPLES

The following examples assume this script is in your $PATH, and your current working directory is a cvs checkout.

  % ls -l
  total 104
  -rwxr-xr-x   1 isao  wheel  37787 May 17 15:42 6076.html*
  drwxr-xr-x   5 isao  wheel    170 Sep 26 17:46 CVS/
  -rwxr-xr-x   1 isao  wheel    593 Feb 27  2006 confirm.html*
  -rwxr-xr-x   1 isao  wheel    458 Feb 20  2006 confirm_test.html*
  -rwxr-xr-x   1 isao  wheel   1935 Mar 15  2006 error.html*

No arguments, just get the head revision and filepath:

  % cvsrevlist.pl
  HEAD    file
  1.25    www/cobrands/ca_secure/bmg/aun/6076.html
  1.8     www/cobrands/ca_secure/bmg/aun/confirm.html
  1.6     www/cobrands/ca_secure/bmg/aun/confirm_test.html
  1.9     www/cobrands/ca_secure/bmg/aun/error.html

Get the revisions for some tags too:

  % cvsrevlist.pl --tag LIVE --tag QA
  LIVE    QA      HEAD    file
  1.24    1.25*   1.25    www/cobrands/ca_secure/bmg/aun/6076.html
  1.8     1.8     1.8     www/cobrands/ca_secure/bmg/aun/confirm.html
  1.6     1.6     1.6     www/cobrands/ca_secure/bmg/aun/confirm_test.html
  1.9     1.9     1.9     www/cobrands/ca_secure/bmg/aun/error.html

Note, the 1.25* above indicates that the QA revision is different from the LIVE one.

Check certain files in the local directory only:

  % ls
  5853.html*            5945.html*            CVS/
  body_greatfun.html*   confirm.html*         confirm_header.html*
  customerservice.html* error.html*           error_header.html*
  images/               pixels.html           

  % cvsrevlist.pl --tag LIVE --tag AMPP_DOWNSTREAM error.html confirm.html
  LIVE    AMPP_DOWNSTREAM HEAD    file
  1.4     1.4     1.4     www/cobrands/ca_secure/nascar/2/error.html
  1.3     1.3     1.3     www/cobrands/ca_secure/nascar/2/confirm.html

Example with notices:

  % ls
  CVS/  cvsrevlist.pl  foo.txt  readme.txt 

  % cvsrevlist.pl --tag LIVE --tag QA --tag FOO
  LIVE    QA      FOO     HEAD    file
  1.1     1.2     n/a     1.3     catools/cvs_tag_fu/cvsrevlist.pl
  n/a     n/a     n/a     n/a     readme.txt       
  notice: locally added file --> readme.txt       
  notice: not in cvs --> foo.txt
  notice: no revision 'QA' on 1/1 files
  notice: no revision 'LIVE' on 1/1 files
  notice: no revision 'HEAD' on 1/1 files
  notice: no revision 'FOO' on 2/1 files

Example quieted output, for piping to other wrapper scripts:

  % cvsrevlist.pl --tag LIVE --tag QA --tag FOO --quiet
  1.1     1.2     n/a     1.3     catools/cvs_tag_fu/cvsrevlist.pl
  n/a     n/a     n/a     n/a     readme.txt       

=head1 BUGS


=head1 AUTHORS

Isao Yagi