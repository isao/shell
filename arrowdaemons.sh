#!/bin/sh -e

which java pkill arrow_server phantomjs >/dev/null || {
    echo "error: missing stuff"
    exit $1
}

pkill -fl arrow_server phantomjs selenium 2>/dev/null && echo "(killed stuff)"

echo "* starting arrow_server"
arrow_server &
sleep 1

echo "* starting selenium"
jarf=$(brew ls selenium-server-standalone | grep .jar)
java -Dwebdriver.firefox.profile=default -jar $jarf
