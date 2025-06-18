#!/bin/bash

LOGFILE=/var/log/alerts.log

# legge le righe che appaiono via via nel file /var/log/alerts.log

tail -f $LOGFILE | while read LOG ; do

    # quando incontra una riga con testo "STOP"
    if [[ $LOG =~ STOP$ ]] 
    then
        # individua l'utente con più processi attivi
        USER=$(ps -eo user | sort | uniq -c | sort -nr | head -1 | awk '{print $2}') 
        echo "trovato, termino tutti i processi di $USER..."

        # e ne termina tutti i processi
        pkill -9 -u `id -u $USER`
    fi

done