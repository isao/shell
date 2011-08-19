#!/bin/sh -x
# Usage: bbedit.sh [file]
# have bbedit open a file (or stdin) on your mac by running this script on a
# remote non-mac. if no arguments, pipe stdin to bbedit.

echo $_

tell=`which yssh ssh | head -1`
mymac=isao@alloutside-lm.corp
thisbox=`whoami`@`hostname`

if [[ $# -eq 0 ]]
then
  $tell $mymac "bbedit --clean --view-top --pipe-title $thisbox:$$" <& 0
else
  if [[ -d $1 ]]
  then
    ref=$(cd $1 && pwd)
  elif [[ -f $1 ]]
  then
    ref=$(cd `dirname $1` && pwd)/$(basename $1)
  else
    echo "neither a dir nor file: $1"
    exit 1
  fi
  $tell $mymac bbedit sftp://$thisbox/$ref
fi
