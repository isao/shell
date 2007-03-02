#!/bin/sh -e

if [ -z "$@" ]
then
	echo "Usage: `basename $0` [path...]"
	echo "No paths specified, using defaults."
	dlist='/var/www/build /var/www/html /var/www/content /var/www/media'
else
	dlist=$@
fi

echo "set modes in: $dlist"

find $dlist \
	-exec chown -v iyagi:apache \{\} \;\
	-exec chmod -v ug=rw,+X,o=u-w \{\} \;

# =rw,+X  set the read and write permissions to the usual defaults,
#         but retain any execute permissions that are currently set.
# g=u-w   set the group bits equal to the user bits, but clear the
#         group write bit.