#!/bin/sh -e

if [[ $PWD != $HOME ]]
then
	echo "this script should be run from $HOME"
	exit
fi

{
	dotdir=`dirname $0`
	cd $dotdir
	echo '- symlink dot-* files to ~'
	for i in dot-*
	do
		echo ln -svi $dotdir/$i ${i/dot-/.}
	done

	
}