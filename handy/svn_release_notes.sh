#!/bin/sh -e

#svn repository
svn_root='http://svn:81/svn/TAN'

bye()
{
	echo 'exiting, no action taken'
	exit $1
}

#make a menu, set $result to user selection
svnmenu()
{
	PS3="$1: "
	shift
	select i in $@
	do
		[[ -z $i ]] && bye 0
		break
	done
	result=${i/\//}
}

#extract the last changed revision number of an svn path
svnpathrev()
{
	result=`svn info $1 |grep '^Last Changed Rev'`
	result=${result/Last Changed Rev: /} #just get number
}

#START
#
clear
cat <<TXT
`basename $0`: create notes for a subversion project based on 2 release tags
  * select a project directory from $svn_root
  * assumes project has these sub-directories: trunk, releases
  * assumes release notes to be taken between tag revisions on the _trunk_

TXT

#GET SVN PROJECT
#
svnmenu 'select the project directory' `svn list $svn_root`
svn_proj="$svn_root/$result"


#GET PREV RELEASE
#
clear
echo "(project selected was $svn_proj)"
echo
echo
svnmenu 'select the previous release' `svn list $svn_proj/releases`
prev_rel_url=$result
svnpathrev "$svn_proj/releases/$prev_rel_url"
prev_rel_num=$result


#GET THIS RELEASE
#
clear
echo "(project selected was $svn_proj)"
echo "(previous release selected was $prev_rel_url)"
echo
svnmenu 'select the current release' `svn list $svn_proj/releases |grep -v $prev_rel_url`
this_rel_url=$result
svnpathrev "$svn_proj/releases/$this_rel_num"
this_rel_num=$result


#MAKE NOTES
#
clear
echo "compiling release notes"
echo "for changes in $this_rel_url since $prev_rel_url"

cat <<TXT > $this_rel_url.txt
release notes for $this_rel_url (rev $this_rel_num)

========================================================================
subversion info:

`svn info $svn_proj/releases/$this_rel_url | egrep '^URL:|^Last'`


========================================================================
files changed in $this_rel_url since $prev_rel_url:

`svn diff $svn_proj/releases/$prev_rel_url $svn_proj/releases/$this_rel_url | grep ^Index`


========================================================================
log messages for $this_rel_url since $prev_rel_url:

`svn log -r$prev_rel_num:$this_rel_num $svn_proj/trunk | egrep -v '^[-r]|^$'`

TXT

clear
cat $this_rel_url.txt
echo "release notes saved to `pwd`/$this_rel_url.txt"