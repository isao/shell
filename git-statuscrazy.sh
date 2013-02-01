#!/bin/sh
# for all git repos, do `git status` and summarize the result
#
# tip: put this in your ~/.gitconfig
#   statuscrazy = !"find . -type d -name .git -execdir path/to/this \\;"
#
# and in some dir containing many git repos, use like:
# % git statuscrazy
#
# output like:
# bbjshint's master ahead 'my/master' by 1 (clean)
# bbjslint's master ahead 'my/master' by 1 (clean)
# bbresults's master ahead 'my/master' by 3 (clean)
# git-heads's master (clean)
# relnote's master (clean)
# shell's master (untracked)
# dotfiles's master (unstaged)
# regex-router's master (unstaged)
# cuppajoe's conf (clean)
# myfork's develop (clean)
# mojito-0.5.3's develop (clean)
# assembler's master (clean)
# photosnear.me's master (clean)
# resource-locator's master (untracked)
# ricloc's master (staged) (unstaged) (untracked)
# touchdown's master (clean)
# wiki's master (clean)
# assemb's master (unstaged)
# bearing's develop (unstaged)
# fooapp's master (unstaged)
# mojitokit's master (staged)
# piegist's master (clean)
# scanfs's develop (unstaged)

/bin/echo -n "$(basename $(pwd))'s "
git status | perl -n \
    -e 'm/^# On branch (\w+)/ && print $1;'\
    -e 'm/nothing to commit, working directory clean/ && print " (clean)";'\
    -e 'm/(ahead|behind) of (\S+) by (\d+) commit/ && print " $1 $2 by $3";'\
    -e 'm/^# Changes not staged/ && print " (unstaged)";'\
    -e 'm/^# Changes to be committed/ && print " (staged)";'\
    -e 'm/^# Untracked files/ && print " (untracked)";'
echo

