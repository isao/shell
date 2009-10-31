#!/bin/sh

#input
owners=$1
shift
paths=$@

#usage
abort()
{
	cat <<USAGE >&2
usage: `basename $0` <ownership> <path1> [... <path2>...]
description: recursively set user and group ownership and modes
error: $1
USAGE
	exit $2
}

#checks
[[ -z $owners ]] && abort 'missing ownership parameter, like "root:b2user"' 1
[[ -z $paths ]] && abort 'missing path parameter(s)' 2
for i in $paths
do
	[[ ! -w $i ]] && abort "can't write to $i" 3
done

#do it
chown -R $owners $paths
chmod -R ug=rwX,o= $paths
