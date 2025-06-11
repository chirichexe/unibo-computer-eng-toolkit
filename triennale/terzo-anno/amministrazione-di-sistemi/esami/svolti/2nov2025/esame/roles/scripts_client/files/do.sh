#!/bin/bash

ROUTER_IP=172.22.22.1
LOGFILE=/var/log/ans.log 

if [ "$#" -lt 1 ]; then     # controlla che la stringa non ha caratteri speciali con le regex con =~
                            # scrivi nel template anche cose per chiedere interattivamente

    echo "Usage: $0 [command] <arg1..argn>"
    exit 1
fi

IPC=$(ip -br -4 a | tail -1 | awk '{ print $3 }' | cut -d"/" -f1 )
# potevo usare hostname con 
# hostname -I (tira fuori indirizzi macchina) | grep -Eo '172\.21\.21\.[0-9]+'

UTENTE=$(whoami)
COMANDO=$1

logger -p local6.info -n $ROUTER_IP "_${IPC}_${UTENTE}_${COMANDO}" 
# potevo anche usare $USER, variabile già definita

# aspetta 10 secondi
sleep 10

# cerca se c'è una riga col formato IPS_COMANDO
sudo tail -20 $LOGFILE |  while read LOG INFOS MESSAGE ; do
# lui usava le regex tipo grep -E "_172.[...]_${USER}_${COMANDO}_"

    if echo $MESSAGE | grep -q "$UTENTE\_$COMANDO"; then

        IPS=$(echo $MESSAGE | cut -d'_' -f1 )
        CURRENT_DATE=$(date +%Y%m%d%k%M%S)
        
        mkdir home/$USER/$CURRENT_DATE

        ssh $IPS "'/usr/local/bin/$COMANDO'" > "$COMANDO".out 2>"$COMANDO".err
        # ricorda i path assoluti!
        # proteggi la stringa, gli apici doppi disinnescano lato client gli effetti degli apici singoli, 

        # potrebbe succedere di eseguire comandi a nome di utenti diversi

    fi

done