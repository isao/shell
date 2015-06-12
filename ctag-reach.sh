#!/bin/sh -e

makeTags()
{
    /usr/local/bin/ctags \
        --languages=typescript \
        --exclude=OPEN_SOURCE_SOFTWARE \
        --exclude=node_modules \
        --exclude=napa \
        --excmd=number \
        --tag-relative=no \
        --fields=+a+m+n+S \
        --recurse
}

alert()
{
    osascript -e 'display notification "Tags generated for ~/work/MRGIT/ReachClient" with title "ctags complete."'
}


cd ~/work/MRGIT/ReachClient/Web/scripts

(makeTags && alert) &