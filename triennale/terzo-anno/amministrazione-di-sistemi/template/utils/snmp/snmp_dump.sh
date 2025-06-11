#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# argomenti
IP=$1
LOGFILE=/var/log/pcap.log

# un'altra istanza dello script potrebbe essere già in esecuzione
RUNNING_INSTANCES=$(pgrep -af "$(basename "$0")" | grep "$IP" | grep -v "$$")
if [[ -n "$RUNNING_INSTANCES" ]]; then
    echo "Another instance of the script is already running with IP $IP. Exiting."
    exit 1
fi

# creo avvio la creazione del pcap
snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"createdump\" &

# attendo che il file di log venga creato
while [[ ! -e "$LOGFILE" ]]; do
    sleep 1
done

# attendo che il file di log venga popolato
sudo tail -n 0 -f "$LOGFILE" | while read -r NEWLOG; do
    
    # prendo il nome del file pcap dal log
    FILENAME=$(echo "$NEWLOG" | awk '{ print $6 }' )
    
    # copio il file pcap dal server remoto
    scp "vagrant@$IP:$FILENAME" $IP.pcap 2>/dev/null

    break
done

# elimino il file pcap
snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"deletedump\"
