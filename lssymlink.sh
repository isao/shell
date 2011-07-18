#!/bin/sh

ls -lA $@ | perl -ne "s|$HOME|~|g; if (m|(\S+ -> \S+)\$|) {print \"\$1\n\";}"
