#!/bin/sh
set -e
set -x

for i in ./*.scpt
do
  osadecompile "$i" > "${i/.scpt/.applescript}"
done
