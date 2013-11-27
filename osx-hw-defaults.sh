#!/bin/sh -eu

[[ "$(whoami)" = root ]] || {
    echo "requires root.\ntry: sudo $0"
    exit 1
}

which pmset tmutil || {
    echo 'must run on a mac'
    exit 3
}

# see also
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# wait 24hrs before moving sleep-storage from ram to disk
# http://osxdaily.com/2013/01/21/mac-slow-wake-from-sleep-fix/
pmset -a standbydelay 86400

# Disable local Time Machine backups, save SSD space
tmutil disablelocal
