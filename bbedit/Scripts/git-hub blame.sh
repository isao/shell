#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
git-hub blame "$BB_DOC_PATH"
