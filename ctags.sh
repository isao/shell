#!/bin/sh -e

# Wrapper script to do BBEdit compatible ctags, optionally when invoked from a
# BBEdit Script Menu.

maketags()
{
    cd "$dir"
    logger "ctags $language $excludes $ctagflags $@"
    ctags $language $excludes $ctagflags $@
}

alert()
{
    osascript -e "display notification \"$dir\" with title \"ctags: $@\""
}

# Handle invocation from BBEdit Script Menu
[[ -n $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"

# Always
ctagflags='--excmd=number --tag-relative=no --fields=+a+m+n+S --recurse'

# Defaults
language=''
excludes='--exclude=node_modules --exclude=.git'
dir="$(git rev-parse --show-toplevel 2>/dev/null)"

# special case for MRGIT
[[ $(git remote -v 2>/dev/null) =~ /MRGIT/_git/ReachClient ]] && {
    dir="$dir/Web/scripts"
    language='--languages=typescript'
    excludes="$excludes --exclude=OPEN_SOURCE_SOFTWARE --exclude=napa"
}

# main
(maketags $@ && alert $(basename "$0")) &
