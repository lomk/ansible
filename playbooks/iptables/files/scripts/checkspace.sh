#!/bin/bash
#CHATID="113942689"
CHATID="-308014529"
KEY="681335735:AAG9ZqkfWCuUy-tr1F-dsg7WDd2e7IANkvQ"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
BOT="/root/SCRIPTS/bot.sh"



df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
#  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 95 ]; then
    MESSAGE="$(hostname): $(date): Running out of space $partition ${usep}%"
#    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$MESSAGE" $URL
    $BOT "$MESSAGE"
  fi
done

