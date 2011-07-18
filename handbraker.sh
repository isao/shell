#!/bin/sh
set -e

#defaults
outdir=.
preset=Normal
oldext=.MTS
newext=.m4v
dryrun=
docs=https://trac.handbrake.fr/wiki/CLIGuide

usage() {
  cat <<TXT >&2
Usage: `basename $0` [options] file1 [file2 [filen..]]

Pass the file references (or a glob) of video files to convert them to .m4v
using HandBrakeCLI. Options:

  -n dry-run (echos commands instead of executing them)
  -o output directory (default is "$outdir")
  -p preset like "Universal" or "Apple TV" (default is "$preset")
  -e new extension (default is "$newext")
  -x old extension (default is "$oldext")
  -d open docs @ $docs

$1
TXT
  exit $2
}

#opt processing
while getopts 'no:p:e:d' opt
do
  case $opt in
    n ) dryrun='echo';;
    o ) outdir=$OPTARG;;
    p ) preset=$OPTARG;;
    e ) newext=$OPTARG;;
    d ) open $docs && exit;;
    ? ) usage '' 9;;
  esac
  shift $(($OPTIND-1)); OPTIND=1
done
[[ -z $@ ]] && usage "error: you must specify one or more input $oldext files"

#main
for i in $@
do
  outfile=$outdir/`basename $i $oldext`$newext
  if [[ -e $outfile ]]
  then
    read -n1 -p "file $outfile exists. overwrite? [y/n] " yn
    if [[ $yn = "n" ]]
    then
      echo
      echo "! skipping $outfile"
      continue
    fi
  fi
  echo "* processing $i -> $outfile"
  $dryrun \
  	HandBrakeCLI --optimize --input=$i --output=$outfile --preset="$preset"
done
