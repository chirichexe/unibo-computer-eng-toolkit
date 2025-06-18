#!/bin/bash

ROUTER_IP=172.22.22.1
LOGFILE=/var/log/ans.log 

if [[ "$#" != 1 ]]; then
    echo "Usage: $0 [command]"
    exit 1
fi

COMMAND=$1

if ! [[ $COMMAND =~ ^[a-zA-Z]+$ ]]; then
    echo "command must not have special characters"
    exit 1
fi

# IPC l'indirizzo del Client su cui è in esecuzione lo script
IPC=$(hostname -I | awk '{ print $2 }' )

# UTENTE il nome dell'utente che sta eseguendo lo script
UTENTE=$USER

# COMANDO la stringa ricevuta come parametro
COMANDO=$1

# invia al Router via syslog un messaggio etichettato local6.info nel formato _IPC_UTENTE_COMANDO_ 
logger -p local6.info -n $ROUTER_IP "_${IPC}_${UTENTE}_${COMANDO}" 

# aspetta 10 secondi
sleep 1

# controlla le ultime 20 righe del file /var/log/ans.log 
tail -20 $LOGFILE |  while read MESSAGE ; do 
# con l'utente exam non funziona! se lo eseguo con sudo mi dice che non sono nella tabella sudoers
# soluzione: cambio i permessi del file di log con
# sudo chgrp exam /var/log/ans.log

    echo "cerco stringa con _${USER}_${COMANDO}_"

    if echo $MESSAGE | awk '{ print $6 }' | grep -q "_${USER}_${COMANDO}_"; then

        echo "trovata!"
        
        IPS=$(echo $MESSAGE | cut -d'_' -f1 )
        CURRENT_DATE=$(date +%Y%m%d%k%M%S)
        
        NEWDIR="/home/$USER/$CURRENT_DATE"
        
        mkdir $NEWDIR

        ssh $IPS "'/usr/local/bin/${COMANDO}'" > "${NEWDIR}/${COMANDO}.out" 2> "${NEWDIR}/${COMANDO}.err"
        # proteggi la stringa, gli apici doppi disinnescano lato client gli effetti degli apici singoli, 

        # potrebbe succedere di eseguire comandi a nome di utenti diversi

    fi

done