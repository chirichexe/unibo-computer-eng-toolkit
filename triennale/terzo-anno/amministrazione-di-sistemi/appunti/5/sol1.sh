#!/bin/bash

function handler_stampa() {
    echo "righe: $T"
    T=0
}

function conta(){
    # non si usa wc -l, 
    # Così legge le righe ogni volta ch ne viene
    # inserita una senza leggere il file dal disco ogni volta

    T=0
    trap stampa USR1 # PROBLEMA! il signal handler non viene ereditato dai processi figli, quindi 
                     # quando lancio la subshell con ((  ))
    tail -f "$1" | ( 
        
        echo "manda segnale coon kill -USR1 $BASHPID per stampare conteggio del file $1"
        trap handler_stampa USR1
        while read riga ; do (( T++ )) ; done 
        
        )    # tail -f non esce mai

    # while sleep 1 ; do date +%N >> test ; done # codice per mettere 
}

test -f "$1" || echo "Usage $0 filename "

conta $1
