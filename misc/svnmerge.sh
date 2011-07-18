#!/bin/bash

#URL: https://svn.pdnfun.info/svn/podshow/branches/features/emailSystemUpgrade4_2007-01-29
URL=`svn info | grep URL: | awk '{print $2}'`
#echo $URL

echo "Finding the version numbers of past merges."
svn log --stop-on-copy $URL | grep -i 'merge '

echo ""
echo "Finding the version number of the trunk"
svn info https://svn.pdnfun.info/svn/podshow/trunk | grep 'Revision:'

echo ""
echo "You are probably looking for the following commands:"
echo "svn merge -r : https://svn.pdnfun.info/svn/podshow/trunk"
echo "svn merge -r : svn+ssh://svn.pdnfun.info/var/svn/podshow/trunk"
echo ""
