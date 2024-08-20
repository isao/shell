#!/bin/sh -e

cd "$(realpath "$(dirname "$BB_DOC_PATH")")"

fork log -C "$(git rev-parse --show-toplevel 2>/dev/null)" -- "$BB_DOC_PATH" > /dev/null
