#!/bin/bash -e
cd "$(dirname "$BB_DOC_PATH")"

line=""
if [[ $BB_DOC_SELSTART_COLUMN -ne $BB_DOC_SELEND_COLUMN || $BB_DOC_SELSTART_LINE -ne $BB_DOC_SELEND_LINE ]]
then
    line="#L$BB_DOC_SELSTART_LINE"
    if [[ $BB_DOC_SELSTART_LINE -ne $BB_DOC_SELEND_LINE ]]
    then
        line="$line-L$BB_DOC_SELEND_LINE"
    fi
fi

git-hub "$BB_DOC_PATH" "$line"
