#!/bin/sh -ex

for i in ./*.scpt
do
  osadecompile "$i" > "${i/.scpt/.applescript}"
done
