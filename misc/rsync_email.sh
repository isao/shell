#!/bin/sh -e
# backup isao@etherwerks.com IMAP email files
# keeps two recent backups
# sync w/ the older backup in case of disaster

rem='isao@etherwerks.com:/usr/home/isao/mail/etherwerks.com/isao/'
bu1=$HOME/Backups/email/isao_backup1/
bu2=$HOME/Backups/email/isao_backup2/
bu0=$HOME/Backups/email/isao_backup_temp/

rsync --recursive --rsh=ssh --cvs-exclude --compress --times --progress\
  --exclude='.mailboxlist'\
  --exclude='Deleted Items'\
  --exclude='Drafts'\
  --exclude='spam'\
  $rem $bu1

mv $bu1 $bu0
mv $bu2 $bu1
mv $bu0 $bu2
