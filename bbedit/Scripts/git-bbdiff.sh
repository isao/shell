#!/bin/sh -e

cd `dirname $BB_DOC_PATH`

$SHELL -c "git difftool --no-prompt --tool bbdiff `basename $BB_DOC_NAME`" &
