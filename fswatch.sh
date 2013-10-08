#!/bin/sh -ex
which fswatch rsync >/dev/null || usg 1 "missing a prerequisite"

rsync_from=$(pwd)/
rsync_to="isao@raisegray-vm0.corp.yahoo.com:repos/$(basename $rsync_from)"

# rsync flags:
# -l aka --links, copy symlinks as symlinks
# -i aka --itemize-changes, output a change-summary for all updates
# -r aka --recursive
# -u skip files that are newer on the receiver
rsync_cmd="rsync -liru --exclude-from=.gitignore --delete $rsync_from $rsync_to"

#sync now
$rsync_cmd

#sync on fs changes
fswatch . "date && $rsync_cmd"
