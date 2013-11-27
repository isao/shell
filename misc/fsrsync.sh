#!/bin/sh -e
usg()
{
	echo $2
	exit $1
}

which fswatch rsync >/dev/null || usg 1 "missing something"

rsync_from=$(pwd)/

default_to="isao@raisegray-vm0.corp.yahoo.com:repos/$(basename $rsync_from)"
rsync_to=${1:-$default_to}

rsync_cmd="rsync --recursive --links --safe-links --update --delete --itemize-changes --exclude-from=$HOME/.gitignore --exclude-from=.gitignore $rsync_from $rsync_to"

#sync now
$rsync_cmd

#sync on fs changes
fswatch . "date && $rsync_cmd"
