#!/bin/sh
#http://wiki.splitbrain.org/shellsnippets
if [ -d "$1" ] ; then   # Only a directory name.
	dir="$1"
	unset file
elif [ -f "$1" ] ; then # Strip off and save the filename.
	dir=$(dirname "$1")
	file="/"$(basename "$1")
else
	# The file did not exist.
	# Return null string as error.
	echo "$1 is not a file or directory."
	return 1
fi
cd "$dir" > /dev/null
echo ${PWD}${file}