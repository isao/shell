#!/bin/sh

# if an npm module cli is in your path & installed as a symlink (npm ln),
# print out the associated parent dir. else just act like `which`

module=${1:-mojito}
modpath=$(which $module)

[[ -L $modpath && $modpath =~ $(npm prefix -g) ]] && {
	cd $(dirname $modpath)
	[[ -L ../lib/node_modules/$module ]] && {
		modpath=$(readlink ../lib/node_modules/$module)
	}
}

echo $modpath
