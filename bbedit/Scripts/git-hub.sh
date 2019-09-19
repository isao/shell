#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
git-hub "$BB_DOC_PATH"
