#!/bin/sh -e

echo "starting arrow_server"
arrow_server &
sleep 2

echo "starting selenium"
jarf=$(ls /opt/brew/Cellar/selenium-server-standalone/2.*/selenium-server-standalone-2.*.jar | tail -1)

java -Dwebdriver.firefox.profile=default -jar $jarf
