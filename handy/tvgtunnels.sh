#!/bin/sh -e
#ssh -f \
#	-L1080:192.168.1.199:80 \
#	-L2080:192.168.1.202:80 \
#	-L3080:192.168.1.204:80 \
#	-L4080:192.168.1.200:80 \
#	-L5080:192.168.1.201:80 \
#	-L3443:192.168.1.207:443 \
#	iyagi@216.135.160.15 -N

#http://localhost:1080/		wiki	
#http://localhost:2080/		jira	
#http://localhost:3080/		hudson
#http://localhost:4080/		crucible
#https://localhost:3443/		dev

if [[ -z "$(ps -A | grep '[a]utossh')" ]]
then
	autossh -M0 -fN \
		-L1080:192.168.1.199:80 \
		-L2080:192.168.1.202:80 \
		-L3080:192.168.1.204:80 \
		-L4080:192.168.1.200:80 \
		-L5080:192.168.1.201:80 \
		-L3443:192.168.1.207:443 \
		iyagi@216.135.160.15 -N
else
	echo "autossh is already running..." 2>&1
fi