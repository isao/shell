#!/bin/sh -e
cd "$(realpath "$(dirname "$BB_DOC_PATH")")"
git-hub compare "$BB_DOC_PATH"
