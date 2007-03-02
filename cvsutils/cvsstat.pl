#!/usr/bin/perl
# cvsstat.pl by iyagi
# parse cvs status output to multi-column-capable tabular format
# passes thru arguments to cvs status, like -R, filenames, or file globs
use warnings;
use English;
my ($o, $re, $vers, $stat, $stag, $file, %stky, $scnt);
$o = "\n".qx/cvs -q status -l @ARGV 2>&1/ or die "error: can't use @ARGV here.";	# newline for matching 1st ?item
compileformat();
while ($o =~ 
	/(?:File:\s([^\t]+?)\ *\t+       	   						# 1
      Status:\s(.+)\s{5}													# 2
      Working\srevision:\t(.+)\s{4}								# 3
      Repository\srevision:\t([^\t]+)\t?.*\s{4}	  # 4
      Sticky\sTag:\t+(\S+)\s?.*\s{4}							# 5
      Sticky\sDate:\t+(\S+)\s{4}									# 6
      Sticky\sOptions:\t(\S+)	  									# 7
		)|(?:         		# alt successful match
      [\n\r]      		# ^anchors$ don't work with -g
      \?\s([^\n\r]+)	# 8
		)/gox) {
  if ($8) {
  	$stat = $vers = $stag = '?';
  	$file = $8;
  	$file =~ s|.+/([^/]+)$|$1|;
  } else {
  	$stat = $2;
  	$vers = $3.(($3 eq $4 || $4 eq 'No revision control file') ? '' : "/$4");
  	$stag = $5 ne '(none)' ? $5 : $6;
  	$file = $1.($7 ne '(none)' ? " ($7)" : '');
  	$file =~ s/^no file (.+)$/$1/;
  	$stky{$stag}++;	# hash for key counting
  }
	write;
}
$scnt = scalar keys %stky;
print "tag tally: $scnt\n" if ($scnt>1);
exit;

sub compileformat
{
	format STDOUT_TOP =
STATUS_________WORK/REPOS_____TAG/DATE_______FILE_(-k_opts)_____________________
.
	format STDOUT =
@<<<<<<<<<<<<< ^<<<<<<<<<<<<< ^<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$stat,         $vers,         $stag,         $file
~              ^<<<<<<<<<<<<< ^<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
               $vers,         $stag,         $file
~              ^<<<<<<<<<<<<< ^<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
               $vers,         $stag,         $file
~              ^<<<<<<<<<<<<< ^<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
               $vers,         $stag,         $file
.
	$OUTPUT_AUTOFLUSH = 1;
	$FORMAT_LINES_PER_PAGE = 99999;
}
