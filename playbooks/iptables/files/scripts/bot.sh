#!/bin/bash

CHATID="113942689"
#CHATID="-308014529"
KEY="681335735:AAG9ZqkfWCuUy-tr1F-dsg7WDd2e7IANkvQ"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT=$1

send_message(){
    if [ ! -z "$1" ]
        then
        curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$1" $URL
    fi
}



if [ -z "$TEXT" ]
then
    echo "error"
else
    send_message "$TEXT"
    #>/dev/null
fi

