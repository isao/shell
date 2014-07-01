#!/bin/sh -e

cd $(dirname "$BB_DOC_PATH")
git difftool --tool bbdiff "$BB_DOC_NAME" &
