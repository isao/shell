#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
gitdir=$(git rev-parse --show-toplevel 2>/dev/null)
/usr/local/bin/fork --git-dir $dir
