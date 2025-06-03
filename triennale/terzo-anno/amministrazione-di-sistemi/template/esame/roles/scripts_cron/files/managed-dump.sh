#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP=$1
LOGFILE=/var/log/pcap.log

snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"createdump\" &

while [[ ! -e "$LOGFILE" ]]; do
    sleep 1
done

sudo tail -n 0 -f "$LOGFILE" | while read -r NEWLOG; do
    echo "nuova riga di log: $NEWLOG"
    
    FILENAME=$(echo "$NEWLOG" | awk '{ print $6 }' )
    scp "vagrant@$IP:$FILENAME" $IP.pcap

    break
done


snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"deletedump\"