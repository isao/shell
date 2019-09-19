#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
git-hub log "$BB_DOC_PATH"
