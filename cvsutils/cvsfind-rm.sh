#!/bin/sh
# Usage: cvs_find_rm.sh [find/file]
# param can be a glob or directory plus find parameter like '-iname "foo?bar"'

if [ $# == 0 ]
then
	f='.'
else
	f=$@
fi

echo 'removing files from cvs'
find $f \
  -type f -not -path '*/CVS/*' \
  -exec cvs rm -f \{\} \;
