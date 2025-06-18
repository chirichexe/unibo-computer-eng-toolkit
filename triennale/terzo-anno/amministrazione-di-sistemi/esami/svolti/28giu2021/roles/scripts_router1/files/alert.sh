#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "usage: $0 <client-ip>"
    exit 1
fi

if ! [[ "$1" =~ ^10\.111\.111\.*+$ ]] ; then
    echo "not a client ip"
    exit 1
fi

IP=$1

# il comando snmp ottiene gli utenti che sono stati presenti sul client negli ultimi 20 minuti
# /bin/last -p -20min | /bin/awk '{ print $1 }' | /bin/sort -u
USERS=$(snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"users\")

echo $USERS >> /root/active.users

echo $USERS | uniq -c | while read NUM USER ; do 

    [[ $NUM -gt 50 ]] && echo "$USER" >> /root/bad.users 

done
