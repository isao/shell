#!/usr/local/bin/python

import fileinput
import string

unshifted = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
shifted =   'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM'
rot13_table = string.maketrans(unshifted, shifted)

for my_line in fileinput.input():
    print string.translate(my_line, rot13_table),
