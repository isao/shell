#!/bin/sh -e
clear

#
#this is a script to do the following:
# 1 use an existing tag/relname, or make a new tag/relname from trunk or branch
# 2 create a release package tgz from tag/relname
# 3 optionally generate release notes (changes between two releases)
# 4 scp to tancubation (iy only)
# 5 cp to lisa (if mounted)
#
#requires: 
# - write access to $tmpdir (/tmp)
# - svn access to $svn_root (http://svn:81/svn/TAN)
#
#usage: just run this script, all input is interactive user input
# - tgz and release notes are created in the current working directory where
#   the script is invoked
#

#
# # configs # #
#

#svn repository
svn_root='http://svn:81/svn/TAN'

#build working directory
tmpdir='/tmp'


#
# # functions # #
#

#
#make a menu, set $result to user selection
#
mkmenu()
{
	#clear
	echo $1
	shift
	PS3="choose: "
	select i in $@
	do
		if [ -z $i ]
		then
			echo
			echo 'exiting, no action taken'
			exit 0
		fi
		break
	done
	result=${i/\//} #chomp trailing slash
	unset i
	#out: $result
}

#
#get a new release name for builds off the trunk
#
getnewrelname()
{
	unset c i ok result
	until [ ! -z $result ]
	do
		c=0
		#clear
		echo "enter a new name for $1 to tag and package"
		echo "or, enter an existing release name to repackage it:"
		for i in `svn list $2`
		do
			i=${i/\//}
			echo -n "$i	"
			((c+=1))
			if [ $c -gt 2 ]
			then
				echo
				c=0
			fi
		done
		echo
		read -p "new release name (${project}_rel_#-##-#_#): ${project}_rel_" result
		result="${project}_rel_$result"
		ok=`perl -e "print 9 if('$result@'=~/^${project}_rel_\d-\d{2}-\d_\d@/);"`
		if [ -z $ok ]
		then
			read -p "error: '$result' format is bad... hit [enter] to continue "
			unset result
		fi
	done
	unset c i ok
	#out: $result
}

#
#extract the last changed revision number of an svn path
#set $result to path last changed revision
#
svnpathrev()
{
	result=`svn info $1 |grep '^Last Changed Rev'`
	result=${result/Last Changed Rev: /} #just get number
}


#
# # main # #
#


#
#check if temp dir exists and is writable
#
[[ ! -e $tmpdir ]] && usage "'$tmpdir' not exists, cannot proceed."
[[ ! -d $tmpdir ]] && usage "'$tmpdir' not a directory, cannot proceed."
[[ ! -w $tmpdir ]] && usage "'$tmpdir' not writeable, cannot proceed."

#
#get project name (ascr, exit180, etc) & svn project base url (http.../ascr/)
#
#  $project  -> render
#  $svn_proj -> http://svn:81/svn/TAN/render
#
mkmenu 'make a package for which project?' `svn list $svn_root`
project="$result"
svn_proj="$svn_root/$result"
if [ $result == 'tools' ]	#project 'tools' is special, it has sub-projects
then
	mkmenu 'which sub-project?' `svn list $svn_proj`
	project="$result"
	svn_proj="$svn_proj/$result"
fi

#
#get release name
#
#  $relname  -> render_rel_0-00-1_0
#
getnewrelname $project $svn_proj/releases
relname="$result"

#
#get source, trunk, branch, or prexisting release
#
#  $svn_from -> http://svn:81/svn/TAN/render/trunk (or branch)
#
if [ -z `svn list $svn_proj/releases | grep $relname | head -1` ]
then
	mkmenu 'make release from trunk or branch?' 'trunk' `svn list $svn_proj/branches`
	if [ $result == 'trunk' ]
	then
		svn_from="$svn_proj/$result"
	else
		svn_from="$svn_proj/branches/$result"
	fi
	#clear
	echo "- saving release $relname"
	echo "  from $svn_from"
	echo "  to   $svn_proj/releases/$relname"
	svn copy -qm "new release $relname from $svn_from"\
		$svn_from $svn_proj/releases/$relname
else
	echo "- repackaging existing $relname"
fi


#
#make package tgz
#
# here are the vars we collected w/ some sample data
#
# user data:
#  $project  -> render
#  $svn_proj -> http://svn:81/svn/TAN/render
#  $svn_from -> http://svn:81/svn/TAN/render/trunk (or branch)
#  $relname  -> render_rel_0-00-1_0
#
# configs:
#  $svn_root -> http://svn:81/svn/TAN
#  $tmpdir   -> /tmp
#
echo "- exporting $svn_proj/releases/$relname"
echo "  to $tmpdir/$relname"
svn export -q $svn_proj/releases/$relname $tmpdir/$relname
echo "- tar $tmpdir/$relname"
echo "  to `pwd`/$relname.tgz"
tar -czf $relname.tgz -C $tmpdir $relname
echo "- cleaning up work files $tmpdir/$relname"
rm -rf $tmpdir/$relname
echo "- build done"


#
#make release notes
#
mkmenu "make release notes for $relname from which previous release?"\
	'none-skip' `svn list $svn_proj/releases | grep -v $relname`
if [ $result != 'none-skip' ]
then
	#
	#get release revision numbers
	#
	prev_relname="$result"
	svnpathrev "$svn_proj/releases/$prev_relname"
	prev_rel_num="$result"
	svnpathrev "$svn_proj/releases/$relname"
	this_rel_num="$result"

	#
	#release notes
	#
	# here are the additional vars we collected w/ some sample data
	#
	# user data:
	#   $prev_relname -> render_rel_0-00-0_0
	#   $prev_rel_num -> 2000
	#   $this_rel_num -> 2022
	#
	#clear
	echo "- compiling release notes"
	echo "  for changes in $relname since $prev_relname"
	cat <<TXT > $relname.txt
release notes for $relname (r$this_rel_num) by $USER@$HOST

========================================================================
subversion info:

`svn info $svn_proj/releases/$relname | egrep '^URL:|^Last'`


========================================================================
files changed in $relname (r$this_rel_num) since $prev_relname (r$prev_rel_num):

`svn diff $svn_proj/releases/$prev_relname $svn_proj/releases/$relname | perl -ne 'print "  * \$1\n" if m/^Index: (.+)\$/;'`


========================================================================
changes in $relname (r$this_rel_num) since $prev_relname (r$prev_rel_num):

`svn log -r$prev_rel_num:$this_rel_num $svn_proj/trunk | perl -ne 'print "  * \$1\n" if m/^([^-r].+)\$/;'`


========================================================================
deploy

files:
  % scp $relname.tgz <user>@<host>://home/adteractive/tgz/
  % ssh <user>@<host>
  % cd /home/adteractive/rel
  % tar -xzf ../tgz/$relname.tgz
  % cd ../tan
  % rm -f render && ln -s ../rel/$relname $project

oracle:

  $USER -- p l e a s e  e d i t


========================================================================
verify

  $USER -- p l e a s e  e d i t


========================================================================
rollback

files:
  % ssh <user>@<host>
  % cd /home/adteractive/tan
  % rm -f render && ln -s ../rel/$prev_relname $project

oracle:

  $USER -- p l e a s e  e d i t


TXT
	#cat $relname.txt
	echo "- release notes saved to `pwd`/$relname.txt"
	echo "  please edit the release notes"
fi


#
#copy to tancubation for iyagi
#
if [ ! -z `egrep -l 'jump1.rwt,.+ssh-rsa' ~/.ssh/known_hosts | head -1` ]
then
	echo '- copying to iyagi@jump1.rwt:., iyagi@10.0.50.170:/home/adteractive/tgz'
	scp -q ./$relname.tgz iyagi@jump1.rwt:. &&\
	ssh iyagi@jump1.rwt 'scp *.tgz iyagi@10.0.50.170:/home/adteractive/tgz'
	ssh iyagi@jump1.rwt 'rm *.tgz'
fi

#
#copy to lisa
#
lisa="/mnt/Lisa/Adteractive_share/Engineering/builds/tan/$project"
if [ -w $lisa ]
then
	echo "- copying to $lisa/$relname.tgz"
	cp ./$relname.tgz $lisa
fi
lisa="/Volumes/ADT/Engineering/builds/tan/$project"
if [ -w $lisa ]
then
	echo "- copying to $lisa/$relname.tgz"
	cp ./$relname.tgz $lisa
fi
