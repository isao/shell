#!/bin/sh -ex
which fswatch rsync >/dev/null || usg 1 "missing a prerequisite"

rsync_from=.
rsync_to="isao@raisegray-vm0.corp.yahoo.com:repos/$(basename $(pwd))/"
rsync_cmd='rsync -iru --exclude .git --exclude-from=.gitignore --delete'

fswatch . "date +%H:%M:%S && $rsync_cmd $rsync_from $rsync_to"
