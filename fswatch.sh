#!/bin/sh -ex
which fswatch rsync >/dev/null || usg 1 "missing a prerequisite"

rsync_from=$(pwd)/
rsync_to="isao@raisegray-vm0.corp.yahoo.com:repos/$(basename $rsync_from)"

rsync_cmd="rsync --recursive --links --safe-links --update --delete --itemize-changes --exclude-from=.gitignore $rsync_from $rsync_to"

#sync now
$rsync_cmd

#sync on fs changes
fswatch . "date && $rsync_cmd"
