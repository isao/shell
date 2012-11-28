#!/bin/sh -e

which java pkill arrow_server phantomjs >/dev/null || {
    echo 'error: missing stuff, if arrow not installed globally cd to mojito dir'
    exit $1
}

cleanup() {
	pkill -fl arrow_ phantomjs selenium- firefox-bin 2>/dev/null \
	    || echo 'was clean'
}

cleanup
trap 'cleanup && exit 1' INT

echo '* starting selenium'
set -x
jarf=$(brew ls selenium-server-standalone | grep .jar)
java -Dwebdriver.firefox.profile=default -jar $jarf


# echo "* starting arrow_server"
# arrow_server &

# echo "* starting arrow_selenium"
# arrow_selenium --open=firefox
