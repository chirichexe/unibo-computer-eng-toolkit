#!/bin/bash

FILEALERT="/var/log/alerts.log"

touch "$FILEALERT"

chmod 640 "$FILEALERT"

tail -f -n 0 "$FILEALERT" | grep --line-buffered -w STOP | while read LINE ; do
	# Scarto root altrimenti non funziona più nulla
	USER=$(ps axho user | sort | uniq -c | grep -v root | sort -nr | head -n1 | awk '{ print $2 }')
	ps axho pid --user "$USER" | while read PID ; do
		kill -9 "$PID"
	done
done
