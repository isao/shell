#!/bin/bash -e

# project_dir=$(pkg-root "$(dirname "$BB_DOC_PATH")")
cd "$(realpath "$(dirname "$BB_DOC_PATH")")"

project_dir="$(git rev-parse --show-toplevel)"

file_ref="$BB_DOC_PATH:$BB_DOC_SELSTART_LINE:$BB_DOC_SELEND_COLUMN"

code "$project_dir" --goto "$file_ref" >/dev/null
