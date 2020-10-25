#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

chmod +x $DIR/scripts/*

mkdir -p /etc/slack
cp -r "$DIR/scripts/." "/etc/slack/"

( crontab -l ; cat cron-jobs ) | crontab -