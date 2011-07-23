#!/bin/sh
dir=$(dirname "$BB_DOC_PATH")
$SHELL -c "gitx --git-dir='$dir'"
