#!/bin/sh -e

mrgit()
{
    if [[ $dir =~ /MRGIT/[^/]+ ]]
    then
        dir="$dir/Web/scripts"
        language='--languages=typescript'
        excludes='--exclude=OPEN_SOURCE_SOFTWARE --exclude=node_modules --exclude=napa'
    fi
}

makeTags()
{
    cd "$dir"
    ctags $language $excludes $ctagflags
}

alert()
{
    osascript -e "display notification \"$dir\" with title \"ctags: $scriptname\""
}


[[ -n $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"

ctagflags='--excmd=number --tag-relative=no --fields=+a+m+n+S --recurse'
language=''
excludes=''
scriptname="$(basename "$0")"
dir="$(git rev-parse --show-toplevel 2>/dev/null)"

mrgit

(makeTags && alert) &
