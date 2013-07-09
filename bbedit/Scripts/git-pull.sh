#!/bin/sh

cd $(dirname "$BB_DOC_PATH")

#using $SHELL -c '...' so bbedit uses your $PATH and git configs
$SHELL -c "(git pull --log) | logger -t git-pull"
