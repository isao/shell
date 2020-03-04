#!/bin/sh -e

cd "$(dirname "$BB_DOC_PATH")"

/usr/local/bin/fork -C "$(git rev-parse --show-toplevel 2>/dev/null)"
