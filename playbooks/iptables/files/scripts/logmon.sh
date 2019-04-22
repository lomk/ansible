#!/bin/bash
LOGFILE="/var/log/syslog"
TELEGRAM_BOT="/root/scripts/bot.sh"
HOST="webserver"

tail --retry -Fn0 $LOGFILE | \
while read line; do
echo "$line" | grep -q -i "error"
        if [ $? = 0 ]
        then
                $TELEGRAM_BOT "$HOST -- $line"
        fi
done
