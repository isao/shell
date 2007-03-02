#!/bin/bash

usage() {
  cat <<TXT >&2
Usage: `basename $0` [option]... [file]
  -a param
  -b flag
  -c param
TXT
  [ -n $1 ] && exit $1
}

sub() {
  echo "$1->$2"                   #trivial subroutine for demonstration
}

[ $# -eq 0 ] && usage 7           #check for 0 options or parameters

while getopts "a:bc:" opt         #prepend a colon to silence getopts errors
do																#colon after a letter for option w/parameter
  case $opt in
    a ) p1=$OPTARG;;              #set $p1 to $opt's parameter value
    b ) p2='BAR';;                #set $p2 to a string
    c ) p3=$(sub $opt $OPTARG);;  #set $p3 to the output of function sub
    ? ) usage 9;;                 #unknown option found
  esac
  shift $(($OPTIND-1)); OPTIND=1	#remove processed opt/arg from $@
done

echo "options & args -> -a=$p1, -b=$p2, -c=$p3"
echo "remaining args -> $@"
