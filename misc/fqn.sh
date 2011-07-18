#!/bin/sh
# fqn: return the full filename, removing ./ ../ adding `pwd` if necessary
# from http://wiki.linuxquestions.org/wiki/Bash_tips

FILE="$1"

# file		dot relative
# ./file	dot relative
# ../file	parent relative
# /file		absolute
while true; do
	case "$FILE" in
		( /* ) 		
		# Remove /./ inside filename:
		while echo "$FILE" |fgrep "/./" >/dev/null 2>&1; do
			FILE=`echo "$FILE" | sed "s/\\/\\.\\//\\//"`
		done
		# Remove /../ inside filename:
		while echo "$FILE" |grep "/[^/][^/]*/\\.\\./" >/dev/null 2>&1; do
			FILE=`echo "$FILE" | sed "s/\\/[^/][^/]*\\/\\.\\.\\//\\//"`
		done
		echo "$FILE"
		exit 0
		;;
		
		(*)
		FILE=`pwd`/"$FILE"
		;;
	esac
done