#!/bin/sh -e
usage()
{
  echo $1
  echo 'Usage:' `basename $0` '[--help] file [msg]'
  exit 7
}

info()
{
  clear
  {
    cat <<INFO
NAME
  done.sh - log completed items from your cvs versioned todo list

SYNOPSIS
  Usage: `basename $0` [--help] file.txt [msg]

DESCRIPTION
  You have a plain text file in which you record things to do.
  You have a plain text file for completed items (that you don't need to edit).
  They are in the same directory in cvs, and are named like "__.txt" and
  "__done.txt", where "__" could be 'todo' or 'work' etc.

  Add items to 'todo.txt' and commit to cvs.

  Delete items from 'todo.txt', run this script, and the deletions will be
  logged to 'tododone.txt', keeping a record of your accomplishments.
INFO
  } | less
  exit 9
}

todofile=$1
donefile=${todofile/.txt/done.txt}

[ -z $1 ]          && usage
[ '--help' == $1 ] && info
[ ! -w $todofile ] && usage 'Error: to do list file not available. Must end with ".txt". Try --help.'
[ ! -w $donefile ] && usage 'Error: completed items file not available. Must end with "done.txt". Try --help.'

cvs -q update $donefile
cvs -q diff -u -b -0 $todofile | egrep ^-.+ >> $donefile && echo >> $donefile
cvs -q commit -m "$2 " $todofile $donefile

# diff opts
# -u Use the unified output format.
# -b Ignore changes in amount of white space.
# -# Number of lines of context around diff
