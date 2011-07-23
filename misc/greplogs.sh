#!/bin/bash

#logs copied here with rsynclogs.sh
dir=/tmp/logs

usage()
{
	cat <<MSG >&2
Usage: $(basename $0) [egrep parameters] <pattern>
zgrep files for <pattern> from $dir. i.e. $f --context=2 'foo.+bar'
MSG
	exit 1
}

[[ -z $@ ]] && usage

zgrep --with-filename $@ $dir/*/{access,error}*
