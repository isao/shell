#!/bin/sh -e

echo "starting arrow_server"
arrow_server &

echo "starting selenium"
java -jar /opt/brew/Cellar/selenium-server-standalone/2.24.1/selenium-server-standalone-2.24.1.jar -p 4444
