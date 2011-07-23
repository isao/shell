#!/bin/bash

#dest dir
dir=/tmp/logs

#yssh or ssh...
rsh=`which yssh ssh| head -1`

#change these...
hosts="golduck.mobile.sp2.yahoo.com xatu.mobile.sp2.yahoo.com charmeleon.mobile.re3.yahoo.com"

#...or specify them as command line arguments to override
[[ ! -z $@ ]] && hosts=$@

for i in $hosts
do
  echo "* $dir/$i"
  mkdir -p $dir/$i
  rsync --rsh=$rsh --compress --times --verbose \
    --exclude='*cache*' --exclude='*.pid' \
    --exclude='*mutex*' --exclude='*.md5' \
    $i:/home/y/logs/yapache/* $dir/$i
done
