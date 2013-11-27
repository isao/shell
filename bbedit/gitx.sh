#!/bin/sh

dir=$(dirname "$BB_DOC_PATH")
gitdir=$(cd $dir && git rev-parse --show-toplevel)
/usr/local/bin/gitx --git-dir="$gitdir"
