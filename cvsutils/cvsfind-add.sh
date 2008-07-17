#!/bin/sh

if [ $# == 0 ]
then
	f='.'
else
	f=$@
fi

find $f \
  -type f -not -path '*/CVS/*' \
  -exec cvs add \{\} \;