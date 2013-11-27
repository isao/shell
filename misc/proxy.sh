#!/bin/sh

# use proxy if available
# replaces line below in ~/.ssh/config
#   ProxyCommand  /usr/bin/nc -x 127.0.0.1:9080 %h %p

if nc 127.0.0.1 1080 >/dev/null 2>&1 </dev/null
then
  exec nc -x 127.0.0.1:1080 "$@"
else
  exec nc "$@"
fi
