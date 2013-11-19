#!/bin/sh -e
# https://gist.github.com/isao/5544779

# default source branch containing the release commits
srcdefault=develop

# the branch all releases are landed on, tagged on, and published from
relbranch=master

# 1st arg is the release number, i.e. 0.1.2
relnum=$1

# optional 2nd arg is the commit representing the release
# if omitted, $srcdefault is used
# i.e. upstream/develop, head^^, b300f84, etc. see `man gitrevisions`
srcref=${2:-$srcdefault}

# if $srcref == $mergeback, merge back after stamping & tagging
# enables release tag to be reachable from the dev branch, and for the
# package.json version to stay in sync
mergeback=$srcdefault

# temporary release branch name
tmpbranch=rel-$relnum

# last tagged release as told by `git describe --abbrev=0`
lastnum=

#
#   funcs
#

usg() {
    this=$(basename $0)
    cat <<ERR >&2
* err: $2
usage: $this <semver> [source]
Run this script in your git repo. It will prompt to confirm the local changes
that will be made.

options:
  semver  version to assign to release & it's tag, i.e 1.2.3. Required.
  source  git reference to base release on. Default is "$srcdefault".
          Can be a branch name, sha, etc. See "man gitrevisions"
examples:
  $this 0.6.7 develop
  $this 1.2.3 upstream/develop
  $this 1.2.3 b300f84

ERR
    exit $1
}

exists() {
    test -n $1 && git log --oneline $1 > /dev/null 2>&1
}

confirm() {
    cat <<CONFIRM
-- Please review --
* The release commit will be based on "$srcref". The latest commits are:
`git log -6 --format='  %h %s (%aN)' $srcref`
* The latest release was "$lastnum"
* The package.json version number will be updated to "$relnum"
* The release will be merged onto $relbranch and tagged "v$relnum"
CONFIRM
    if [[ $mergeback = $srcref ]]
    then
        echo "* Since source is \"$mergeback\", the release commits will be merged back."
        echo
    fi
    read -p 'continue? (Yy) ' -n 1
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo
        exit 0
    fi
}

read_json() {
    perl -ane "m/\"$1\":\s*\"([^\"]+)\"/ && print \$1" $2
}

stamp() {
    perl -p -i~ -e "s/\"version\":\s*\"$1\"/\"version\": \"$2\"/" $3
    diff $3~ $3 && echo 'version NOT updated'
    rm $3~
    echo "* package version changed from $1 to $2"
}


#
#   checks
#

which git perl >/dev/null || usg 1 "missing executable"
[[ -n $relnum ]] || usg 3 "missing release number"
[[ -n $srcref ]] || usg 3 "missing source reference"
exists $srcref   || usg 5 "git reference '$srcref' doesn't exist.\nspecify the correct source branch name or ref."


#
#   main
#

relnum=${relnum#v}; #rm leading "v" if needed
lastnum=$(git describe --abbrev=0)
cd $(git rev-parse --show-toplevel)

# you sure?
confirm

# checkout temp release branch
echo "* making branch $tmpbranch off $srcref"
git checkout -b $tmpbranch $srcref

echo "* stamping package.json version $relnum"
stamp $(read_json version package.json) $relnum package.json
git commit -m v$relnum package.json || echo

echo "* merging $tmpbranch onto $relbranch"
git checkout -q $relbranch
gitdesc=$(git describe $srcref)
git merge -m "merge release $relnum (based on $gitdesc)" $tmpbranch

echo "* tagging v$relnum"
git tag -fm "v$relnum (based on $gitdesc)" v$relnum

if [[ $mergeback = $srcref ]]
then
    echo "* merging back to $mergeback"
    git checkout $srcref
    git merge --no-edit $relbranch
fi

echo "* cleanup $tmpbranch"
git branch -d $tmpbranch

echo "* done."

cat <<TODO
Now you will want to do these things:
  git push up master:master $([[ $mergeback = $srcref ]] && echo "\n  git push up $mergeback:$mergeback")
  git push up --tags
  npm publish .         # or something like: npm publish . --tag beta
TODO
