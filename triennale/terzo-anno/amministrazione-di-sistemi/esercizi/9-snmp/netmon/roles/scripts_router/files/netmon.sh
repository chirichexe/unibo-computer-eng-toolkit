#!/bin/bash

LOG_FILE="/var/log/newconn"

# Inizio connessione SSH
tcpdump -lnp -i eth1 'tcp[tcpflags] & tcp-syn != 0 and port 22 and src net 10.1.1.0/24 and dst net 10.2.2.0/24' 2>/dev/null |
while read line; do
    echo "$(date +'%b %d %H:%M:%S') router ssh-conn START ${line}" | logger -p local2.info -t netmon
    echo "$(date +'%b %d %H:%M:%S') START ${line}" >> $LOG_FILE
done &

# Fine connessione SSH
tcpdump -lnp -i eth1 'tcp[tcpflags] & tcp-fin != 0 and port 22 and src net 10.1.1.0/24 and dst net 10.2.2.0/24' 2>/dev/null |
while read line; do
    echo "$(date +'%b %d %H:%M:%S') router ssh-conn END ${line}" | logger -p local2.info -t netmon
    echo "$(date +'%b %d %H:%M:%S') END ${line}" >> $LOG_FILE
done &
