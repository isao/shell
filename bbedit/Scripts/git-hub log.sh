#!/bin/sh -e
cd "$(realpath "$(dirname "$BB_DOC_PATH")")"
git-hub log "$BB_DOC_PATH"
