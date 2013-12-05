#!/bin/sh -e

docdir=$(dirname "$BB_DOC_PATH")
gitdir=$(cd "$docdir" && git rev-parse --show-toplevel)

/usr/local/bin/gitx --git-dir="$gitdir"
