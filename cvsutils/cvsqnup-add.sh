#!/bin/sh -e

if [ -z $@ ]
then
	f='.'
else
	f=$@
fi

cvs -nq update -l $f | egrep -v '.DS_Store$|\.[#_].+$' | \
perl -ne 's/^\? (.+)$/cvs add "$1"; cvs ci -m "adding" "$1";/g && print qx/$_/'