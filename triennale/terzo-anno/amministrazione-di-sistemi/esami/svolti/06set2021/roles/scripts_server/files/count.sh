#!/bin/bash

# Realizzare su server1 (sarà poi disponibile su tutti i server) uno script /home/count.sh che resti
# continuamente in ascolto di pacchetti in arrivo dalla rete dei client che richiedono l'apertura di una
# nuova connessione sulla porta ssh. L'indirizzo sorgente deve essere scritto, attraverso rsyslog, sul
# file /var/log/conn.log

tcpdump -lnp -i eth1 'tcp[tcpflags] & tcp-syn != 0 and src net 10.100.0.0/16 and dst net 10.200.1.0/24 and dst port 22' |  
while read TIME IP SOURCE DIR DEST RESTO ; do
    echo $SOURCE | cut -d'.' -f1 | logger -p local1.info
done