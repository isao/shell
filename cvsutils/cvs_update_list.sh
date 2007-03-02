#!/bin/sh -e
cvsdirs="engine_v2 www/publisher_integration www/cobrands/TLG"
basedirs="/Users/isao/Cvs"

#pick a basedir
for i in $basedirs
do
	if [ -d $i ]
	then
		base=$i
		break
	fi
done

#update cvs sandboxes
for i in $cvsdirs
do
	( d=$base/$i
		if [ -d $d/CVS ]
		then
			cd $d
			echo "updating $d"
			cvs -q up -dP | egrep -v '\.DS_Store$|\._.+$'
		else
			echo "warning: $d is not a cvs sandbox"
		fi
	) # parens makes subshell, so it exits to same working dir each loop
done
