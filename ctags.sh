#!/bin/bash -e

# Wrapper script to do BBEdit compatible ctags when invoked by any of the these:
#   1. from the command line
#   2. from a BBEdit Script Menu
#   3. from a .git/hooks file like post-checkout or post-merge

maketags()
{
    cd "$base"
    #logger "ctags $language $excludes $ctagflags $*"
    ctags $language $excludes $ctagflags $@ $paths
}

alert()
{
    osascript -e "display notification \"$base\" with title \"ctags: $1\""
}

# Handle invocation from BBEdit Script Menu
[[ -n $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"

# Always
ctagflags='--excmd=number --tag-relative=no --fields=+a+m+n+S --recurse'

# Defaults
language=''
excludes='--exclude=node_modules --exclude=.git'
base="$(git rev-parse --show-toplevel 2>/dev/null)"
paths=

# special case for MRGIT
[[ $(git remote -v 2>/dev/null) =~ /MRGIT/_git/ReachClient ]] && {
    paths='Web/scripts Web/typescript'
    language='--languages=typescript'
    excludes="$excludes --exclude=OPEN_SOURCE_SOFTWARE --exclude=napa"
}

# pass through any args if not run as a git hook
if [[ -n $GIT_DIR ]]
then
    args=''
else
    args=$*
fi

# main
(maketags $args && alert "$(basename "$0")") &
