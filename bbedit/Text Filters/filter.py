#!/usr/bin/python

import fileinput
import re

s = fileinput.input()
for line in s:
	line = line.strip()
	print re.sub(r'[a-z]',r'',line)
