#!/bin/bash

# Common group chat's ID
CHAT_ID="104182620"
# Common token
TOKEN="495419836:AAGlzK-XYtxhlHoGwwKZJ-HkDdCJElrTQ2M"

/usr/bin/curl -s --header 'Content-Type: application/json' --request 'POST' --data \
		"{\"chat_id\":\"$CHAT_ID\",\"text\":\"$1\"}" "https://api.telegram.org/bot$TOKEN/sendMessage" | grep -q '"ok":false,'
if [ $? -eq 0 ] ; then exit 1 ; fi
