#!/bin/sh -e

cd "$(realpath "$(dirname "$BB_DOC_PATH")")"

fork -C "$(git rev-parse --show-toplevel 2>/dev/null)"
