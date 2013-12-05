#!/bin/sh
# Usage: bbedit.sh [file|dir]
# uses ssh to tell bbedit on my mac to open file local to this script using
# scp. if no argment passed to this script, pipe stdin over ssh to bbedit
#
# e.g.:
#   linuxbox% bbedit.sh /etc/hosts
#   linuxbox% ps auxw | bbedit.sh

tell=ssh
mymac=isao@YOUR.HOST.NAME.HERE
thisbox=`whoami`@`hostname`

if [[ $# -eq 0 ]]
then
  #pipe stdin over ssh to bbedit
  $tell $mymac "bbedit --clean --view-top --pipe-title $thisbox:$$" <&0

else
  if [[ -d "$1" ]]
  then
    #full path to dir; opening a dir over scp broken in bbedit 10.0.1?    
    ref=$(cd "$1" && pwd)

  else
    #full path to file
    ref=$(cd $(dirname "$1") && pwd)/$(basename "$1")
  fi

  $tell $mymac bbedit "sftp://$thisbox/$ref"
fi
