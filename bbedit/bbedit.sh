#!/bin/sh
# Usage: bbedit.sh [file]
# have bbedit open a file (or stdin) on your mac by running this script on a
# remote non-mac. if no arguments, pipe stdin to bbedit.

tell=`which yssh ssh | head -1`
mymac=isao@alloutside-lm.corp
thisbox=`whoami`@`hostname`

if [[ $# -eq 0 ]]
then
  #pipe stdin over ssh to bbedit
  $tell $mymac "bbedit --clean --view-top --pipe-title $thisbox:$$" <&0

else
  if [[ -d $1 ]]
  then
    #full path to dir; opening a dir over scp broken in bbedit 10.0.1?    
    ref=$(cd $1 && pwd)

  elif [[ -f $1 ]]
  then
    #full path to file
    ref=$(cd `dirname $1` && pwd)/$(basename $1)
  fi

  $tell $mymac bbedit sftp://$thisbox/$ref
fi
