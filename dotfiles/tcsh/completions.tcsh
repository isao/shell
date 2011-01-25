#
# built-in completions
#

complete {cd,lsd,pushd,popd,rmdir} 'C/*/d/'

complete chgrp 'p/1/g/'

complete df 'c/--/(all human-readable kilobytes local megabytes)/'
complete du 'c/--/(all total dereference-args human-readable kilobytes count-links dereference megabytes separate-dirs summarize one-file-system exclude-from exclude max-depth/'

complete {find,findfile.sh} 'n/-{,i}name/f/' 'n/-newer/f/' 'n/-{,n}cpio/f/' 'n/-exec/c/' 'n/-ok/c/' 'n/-user/u/' 'n/-group/g/' 'n/-fstype/(nfs 4.2)/' 'n/-type/(b c d f l p s)/' 'c/-/(and atime cpio ctime depth empty exec fstype group iname inum iregex ls maxdepth mindepth mtime name ncpio newer nogroup not nouser ok or path perm print prune regex size type user xdev)/' 'p/*/d/'
complete {{,e,f}grep,codegrep.sh} 'c/--/(after-context before-context context count exclude file files-with-matches files-without-match fixed-strings include invert-match no-filename no-messages only-matching perl-regexp recursive with-filename)/'

complete kill 'c/%/j/' 'c/-/S/'
complete killall 'c/-/S/' 'p/1/(-)/'

#see http://hea-www.harvard.edu/~fine/Tech/tcsh.html
complete ln 'C/?/f/' 'p/1/(-s)/' 'n/-s/x:[first arg is path to original file]/' 'N/-s/x:[second arg is new link]/'
complete {man,whereis,which} 'p/*/c/'
complete su 'c/-/(f l m)/' 'p/*/u/'
complete sudo 'p/1/c/'
complete tcpdump 'n@-i@`ifconfig -l`@'
complete wget 'c/--/(background debug verbose non-verbose output-document timestamping no-host-directories recursive)/'
complete uncomplete 'p/*/X/'

# completion sets using personal lists
set _myhosts=(`cat -s $_mysrcs/hosts.txt| grep -v '^#'`)
set _myusers=(`cat -s $_mysrcs/users.txt`)

complete {host,nslookup,ping,route} 'p/*/$_myhosts/'

#complete chown 'c/--/(changes silent quiet verbose reference recursive help version)/' 'p/*/f/'
complete chown 'c/--/(changes help quiet recursive reference silent verbose version)/' 'c/*:/$_myusers//' 'p/1/$_myusers/:' 'p/*/f/'

#complete rsync 'c/--/(checksum copy-links cvs-exclude delete delete-excluded dry-run exclude-from= exclude= ignore-times include-from= include= modify-window= progress quiet recursive rsh=$CVS_RSH safe-links size-only times update verbose)/' 'p/*/f/'
complete rsync 'c/*@/$_myhosts//' 'c/--/(checksum copy-links cvs-exclude delete delete-excluded dry-run exclude-from= exclude= ignore-times include-from= include= modify-window= progress quiet recursive rsh=$CVS_RSH safe-links size-only times update verbose)/' 'p/*/f/'

# From Michael Schroeder <mlschroe@immd4.informatik.uni-erlangen.de> 
# This one will ssh to fetch the list of files
complete scp 'c%*@*:%`set q=$:-0;set q="$q:s/@/ /";set q="$q:s/:/ /";set q=($q " ");$CVS_RSH $q[2] -l $q[1] ls -dp $q[3]\*`%' 'c%*:%`set q=$:-0;set q="$q:s/:/ /";set q=($q " ");$CVS_RSH $q[1] ls -dp $q[2]\*`%' 'c%*@%$_myhosts%:' 'C@[./$~]*@f@' 'n/*/$_myhosts/:'
complete ssh 'c/*@/$_myhosts//' 'p/*/$_myusers/@'


#
# app completions
#
if(-X bbedit) complete bbedit 'c/--/(background clean create front-window maketags new-window print pipe-title scratchpad worksheet view-top resume wait)/'

if(-X brew) complete brew 'c/--/(verbose prefix cache config)/' 'p/1/(install list info home rm remove create edit ln link unlink prune outdated deps uses doctor cat cleanup update log fetch)/' 'n~{deps,uses,cat,cleanup,log,home,edit}~`brew list`~' 'n/info/(--github --all)/'

if(-X git) then
	#if(-X git) complete git 'p/1/(add bisect branch checkout clone commit config diff fetch grep init log merge mv pull push rebase reset rm show status tag)/'
  #set gitcmd='add am annotate apply archimport archive bisect blame branch bundle cat-file check-attr check-ref-format checkout checkout-index cherry cherry-pick citool clean clone commit commit-tree config count-objects cvsexportcommit cvsimport cvsserver daemon describe diff diff-files diff-index diff-tree difftool fast-export fast-import fetch fetch-pack filter-branch fmt-merge-msg for-each-ref format-patch fsck fsck-objects gc get-tar-commit-id grep gui hash-object help http-backend http-fetch http-push imap-send index-pack init init-db instaweb log lost-found ls-files ls-remote ls-tree mailinfo mailsplit merge merge-base merge-file merge-index merge-octopus merge-one-file merge-ours merge-recursive merge-resolve merge-subtree merge-tree mergetool mktag mktree mv name-rev notes pack-objects pack-redundant pack-refs patch-id peek-remote prune prune-packed pull push quiltimport read-tree rebase receive-pack reflog relink remote remote-ftp remote-ftps remote-http remote-https repack replace repo-config request-pull rerere reset rev-list rev-parse revert rm send-email send-pack shell shortlog show show-branch show-index show-ref stage stash status stripspace submodule symbolic-ref tag tar-tree unpack-file unpack-objects update-index update-ref update-server-info upload-archive upload-pack var verify-pack verify-tag whatchanged write-tree'
  set gitcmd='add am annotate apply archive bbdiff bisect blame branch bundle cat-file checkout cherry cherry-pick citool clean clone commit commit-tree config describe diff diff-files diff-index diff-tree difftool fast-export fast-import fetch filter-branch format-patch fsck gc grep gui help init log ls-files ls-remote ls-tree merge merge-base merge-file merge-one-file merge-ours merge-recursive merge-resolve merge-subtree merge-tree mergetool mktag mktree mv name-rev notes patch-id prune prune-packed pull push read-tree rebase reflog relink remote repack replace repo-config request-pull rerere reset rev-list rev-parse revert rm send-email shortlog show show-branch show-index show-ref stage stash status stripspace submodule symbolic-ref tag tar-tree update-index update-ref update-server-info var verify-tag whatchanged write-tree'
  #alias _gitdir 'git rev-parse --show-cdup'
  complete git "p/1/($gitcmd)/" "n/help/($gitcmd)/" 'n~checkout~F:.git/refs/heads~' 'N~branch~F:.git/refs/heads~' 'n/remote/(show add rm prune update)/' 'N/remote/`git remote`/'
endif

if(-X nano) complete nano 'c/--/(autoindent backup help nowrap)/'

if(-X port) complete port 'p/1/(search info variants deps dependents install uninstall activate deactivate installed location contents provides sync outdated upgrade clean echo list version selfupdate help)/' 'n/echo/(current active inactive installed requested uninstalled outdated)/'

if(-X svn) complete svn 'p/1/(add blame cat checkout cleanup commit copy delete diff export help import info list lock log merge mkdir move propdel propedit propget proplist propset resolved revert status switch unlock update)//' 'n/prop{del,edit,get,set}/(svn:executable svn:externals svn:ignore svn:keywords svn:mime-type)//' 'c/--/(quiet verbose username password)/'
