#!/bin/sh -e
cd `dirname $BB_DOC_PATH`

tcsh -c "git difftool --no-prompt --tool bbdiff `basename $BB_DOC_NAME`" &
