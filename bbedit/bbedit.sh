#!/bin/sh
#  Usage: bbedit.sh file

tell=`which yssh ssh | head -1`

mac=isao@alloutside-lm.corp

$tell $mac bbedit sftp://`whoami`@`hostname`/`pwd`/$1
