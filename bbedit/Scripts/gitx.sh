#!/bin/sh

# using $SHELL to pick up my $PATH
# you can use git gui or gitk if you prefer

cd `dirname "$BB_DOC_PATH"`
$SHELL -c gitx
