#!/bin/sh
for i in 'daily weekly monthly'
do
  sudo periodic $i
  logger "$i done"
done
