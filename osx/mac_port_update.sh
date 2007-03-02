#!/bin/sh

sudo port selfupdate
sudo port -d sync
sudo portindex
sudo port upgrade installed
