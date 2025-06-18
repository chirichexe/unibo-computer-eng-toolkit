#!/bin/bash

# parametri globali 
LOGFILE=/var/log/req.log

# file temporaneo, necessario in quanto shuf usa file di base
valid_ips=$(mktemp)

function executeQuery() {

    IP=$1
    COMANDO=$2
    UTENTE=$3 # sbaglio o non serve a un cazzo? devo controllare solo i permessi del file
 
    # l'agent è il server
    # fa ls -l nella directory /usr/local/bin del server
    snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"get-bin\" | grep "$COMANDO"  &&

    # il comando dovrebbe fare ls -l .ssh/authorized_keys 
    snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"get-authkeys\" | grep -E "^-rw-------" && 
    # permessi solo scrittura e lettura del proprietario

    # valido, lo aggiungo all'elenco
    echo "$IP" >> $valid_ips

}

# resta in attesa di nuove righe sul file di log
sudo tail -f $LOGFILE | while read li ; do 

    IPC=$(echo "$li" | cut -d'_' -f2) ; 
    UTENTE=$(echo "$li" | cut -d'_' -f3) ; 
    COMANDO=$(echo "$li" | cut -d'_' -f4) ; 

    for ip in {193..254} ; do
        executeQuery "172.22.22.$ip" "$COMANDO" "$UTENTE"  &
    done
    
    WINNER=$(shuf $VALID_IPS | head -1)

    logger -p local6.warn -n $IPC "_${WINNER}_${UTENTE}_${COMANDO}_"

    rm -rf $VALID_IPS

done
