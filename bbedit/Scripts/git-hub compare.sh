#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
git-hub compare "$BB_DOC_PATH"
