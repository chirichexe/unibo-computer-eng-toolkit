#!/bin/bash

# parametri globali 
LOGFILE=/var/log/req.log

# configurare gli agent snmp in modo tale da 

# resta in attesa di nuove righe sul file di log
tail -f $LOGFILE | while read li ; do 

    IPC=$(echo "$li" | cut -d'_' -f2) ; 
    UTENTE=$(echo "$li" | cut -d'_' -f3) ; 
    COMANDO=$(echo "$li" | cut -d'_' -f4) ; 

    for 

done