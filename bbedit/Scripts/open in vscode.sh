#!/bin/bash -e

project_dir=$(pkg-root "$(dirname "$BB_DOC_PATH")")

file_ref="$BB_DOC_PATH:$BB_DOC_SELSTART_LINE:$BB_DOC_SELEND_COLUMN"

code --goto "$file_ref" "$project_dir" > /dev/null
