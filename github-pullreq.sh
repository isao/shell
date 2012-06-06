#!/bin/bash -e
# based on Vladimir Panteleev's https://gist.github.com/1885859

# usage: github-pullreq.sh [remote]
# invoke from your local github fork to:
# - push local topic branch to remote
# - open corresponding github.com pull request page 
# n.b. will use the remote name specified as an (optional) arg. If ommitted,
# the first one containing your github user name will be used
#
# put this in your .gitconfig to use like: git pushreq [remote]
# [alias]
#   pushreq = !github-pullreq.sh

die() {
  echo "$@" >&2
  exit 1
}

#
#   vars
#

branch=$(git name-rev --name-only HEAD 2>/dev/null)
ghusr=$(git config --get github.user)

# pass remote name as arg, or assume it's the first one with your username
ghrem=${1:-$(git remote -v | grep -Fm1 $ghusr/ | cut -f 1)}
ghuri=$(git remote -v | grep -m1 github.com: | egrep -o "$ghusr/\w+")

#
#   checks
#

[[ -n $branch ]] || die 'no branch!'
[[ $branch != master && $branch != develop ]] || die 'use topic branch'
[[ -n $ghusr ]] || die "github.user not set"
[[ -n $ghrem ]] || die "no remote found for github.user '$ghusr'"

#
#   main
#

# push
git push -v $ghrem $branch

# run this script again to push again, or uncomment git config below to
# enable this behavior:
# % git push -v
# Pushing to git@github.com:isao/mojito.git
# To git@github.com:isao/mojito.git
#  = [up to date]      develop -> develop
#  = [up to date]      master -> master
#  = [up to date]      mu-ie-splice-bug -> mu-ie-splice-bug
# updating local tracking ref 'refs/remotes/myfork/develop'
# updating local tracking ref 'refs/remotes/myfork/master'
# updating local tracking ref 'refs/remotes/myfork/mu-ie-splice-bug'
# Everything up-to-date
#
#git config branch.$branch.remote $ghrem

# in your browser
open https://github.com/$ghuri/pull/new/$branch
