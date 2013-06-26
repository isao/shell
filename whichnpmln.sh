#!/bin/sh

# if an npm module bin is in your path & installed as a symlink (npm ln),
# print the parent dirname of the source package
# ... otherwise act like `which`

module=${1:-mojito}         # mojito
binpath=$(which $module)    # /usr/local/share/npm/bin/mojito

npmprefix=$(npm prefix -g)  # /usr/local/share/npm
npmroot=$(npm root -g)/     # /usr/local/share/npm/lib/node_modules

absdir() {
    cd $(dirname $1) && pwd
}

[[ -L "$binpath" && "$binpath" =~ $npmprefix ]] && {
    cd $(dirname "$binpath")
    link0=$(readlink $module)   # ../lib/node_modules/mojito-cli/bin/mojito
    link1=$(absdir $link0)      # /usr/local/share/npm/lib/node_modules/mojito-cli/bin
    link2=${link1#$npmroot}     # mojito-cli/bin
    modname=${link2%%/*}        # mojito-cli

    [[ -L ${npmroot}${modname} ]] && {
        # /Users/isao/Repos/clistuff/cli
        binpath=$(readlink ${npmroot}${modname})
    }
}

echo $binpath
