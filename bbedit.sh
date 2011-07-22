#!/bin/sh
#  Usage: bbedit.sh file
ssh iyagi@gonzo.internal.mediabolic.com bbedit sftp://`whoami`@`hostname`/`pwd`/$1
