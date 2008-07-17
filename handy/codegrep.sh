#!/bin/sh

usage()
{
	cat <<MSG >&2
Usage: `basename $0` [egrep parameters] <pattern>
Desription: egreps files for <pattern> recursively from cwd, skipping cvs/svn dirs and image files. Tip: put optional parameters to egrep before <pattern>.
Example: `basename $0` --invert-match 'foo.+bar'
MSG
	exit 1
}

[ -z $1 ] && usage

find . \( -type d \( -name .svn -or -name CVS \) \) -prune -or \
  -type f -not \( -name '*.gif' -name '*.jpg' -name '*.jpeg' -name '*.png' \) \
  -exec egrep --with-filename --line-number --no-messages $@ '{}' \;