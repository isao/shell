#!/bin/sh

module=${1:-mojito}
modpath=$(which $module)

[[ -L $modpath && $modpath =~ $(npm prefix -g) ]] && {
	cd $(dirname $modpath)
	[[ -L ../lib/node_modules/$module ]] && {
		modpath=$(readlink ../lib/node_modules/$module)
	}
}

echo $modpath
