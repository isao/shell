#!/bin/sh

dir=$(dirname "$BB_DOC_PATH")
cd "$dir"

#display message...
if [[ `$SHELL -c 'which growlnotify'` ]]
then
  #...as a growl notification
  showvia="growlnotify --icon git git-pull $dir"
else
  #...in /var/log/system.log; alternatively use 'cat'
  showvia="logger -t git-pull"
fi

#using $SHELL -c '...' so bbedit uses your $PATH and git configs
$SHELL -c "(git pull --log) | $showvia"
