#!/bin/sh

if [ -z $@ ]
then
	f='.'
else
	f=$@
fi

ls -lA $f | perl -ne "s|$HOME|~|g; if (m|(\S+ -> \S+)\$|) {print \"\$1\n\";}"
