#!/bin/sh -e

{
	cd `dirname $0`
	for i in dot-*
	do
		echo $i - ${i/dot-/.}
	done
}