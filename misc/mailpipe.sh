#!/bin/sh

# see http://seancoates.com/mail-replacement----a-better-hack
# pipe mail from php's mail() function to a file instead of attempting to send
#
# edit .ini setting:
#
#   sendmail_path=/Users/isao/Repos/shell/handy/mailpipe.sh <- path to this file
#
cat >> /tmp/mailpipe.log