#!/bin/sh -e

#cd "$(realpath "$(dirname "$BB_DOC_PATH")")"
#
#fork status -C "$(git rev-parse --show-toplevel 2>/dev/null)" > /dev/null

fork status -C "$(dirname "$BB_DOC_PATH")"
