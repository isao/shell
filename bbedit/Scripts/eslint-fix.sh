#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"
eslint --format unix --fix "$BB_DOC_PATH" | bbresults
