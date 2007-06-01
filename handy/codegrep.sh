#!/bin/sh
#usage: codgrep.sh [grep param] <pattern>
#greps certain files from cwd, using supplied <pattern>
#put optional parameters to grep before <pattern>
#
#ie- display files and line with matching pattern
#  % codegrep.sh <pattern>
#
#ie- display only filenames with
#  % codegrep.sh --files-with-matches <pattern>
#
#ie- display inverted match with
#  % codegrep.sh --invert-match <pattern>

usage()
{
	cat <<MSG >&2
usage: `basename $0` [egrep parameters] <pattern>
greps certain files from cwd, using supplied <pattern>
put optional parameters to grep before <pattern>
MSG
	exit 1
}

[ -z $1 ] && usage

find -E . -type f \
  -not -path '*/.svn/*' \
  -not -path '*/cache/*' \
  -not -iregex '^.*\.(txt|swp|gif|jpg|png|pdf|swf|flv|mp3)$' \
  -exec egrep --with-filename --line-number --no-messages $@ '{}' \;