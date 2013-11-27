#!/bin/sh -ex
o=http://mobile.theonion.com
n=`wget -qO - $o | perl -ne 'm|<a href="(node/\d+?)" target=_top><b>This Week.s Horoscopes</b></a>|gi && print $1'`
wget -qO - $o/content/$n | perl -ne 'm|^<b>[A-Z][a-z]+</b>.+?<br>(.+)<br>.+$|g && print "$1\n"' | bbedit --clean
#bbedit sftp://isao:@ftp.etherwerks.com//usr/home/isao/public_html/onion2.txt
bbedit /Users/isao/Documents/*personal/onion2.txt