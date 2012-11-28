#!/bin/sh -e

#need to do this a lot...
cleanup() {
	pkill -f arrow_ phantomjs selenium- firefox-bin 2>/dev/null || echo 0 kills
}

#yeah, need all of these too
required='java pkill arrow_server phantomjs whichnpmln.sh'

#check for them
which $required >/dev/null || {
    echo 'one of these required executables is not in your path, stopping.'
    echo "  $required"
    exit $1
}

cd $(whichnpmln.sh mojito)
cleanup

#cleanup on SIGINT
trap 'cleanup && exit 1' INT

#start effing selenium in the bg
jarf=$(brew ls selenium-server-standalone | grep .jar)
set -x
java -Dwebdriver.firefox.profile=default -jar $jarf &

#run tests
sleep 9
npm test

#clean up the mess
cleanup
