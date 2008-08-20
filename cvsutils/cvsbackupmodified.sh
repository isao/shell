#!/bin/sh -e
# rename all modified files in your cvs repository with a trailing "~"
# modified files are found with cvs -qn up
# 

if [ -z $@ ]
then
	f='.'
else
	f=$@
fi

cvs -nq update $f |\
	perl -ne 's/^M (.+)$/mv -i $1 $1~/ && print && qx/$_/;'
