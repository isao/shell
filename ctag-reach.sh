#!/bin/sh -e

cd ~/work/MRGIT/ReachClient/Web/scripts
ctags \
    --languages=typescript \
    --exclude=OPEN_SOURCE_SOFTWARE \
    --exclude=node_modules \
    --exclude=napa \
    --excmd=number \
    --tag-relative=no \
    --fields=+a+m+n+S \
    --recurse
