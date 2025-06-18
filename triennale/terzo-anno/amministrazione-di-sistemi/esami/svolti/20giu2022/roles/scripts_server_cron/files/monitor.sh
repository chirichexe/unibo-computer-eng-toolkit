#!/bin/bash

SOGLIA=2

function ask_client() {
    local IP="$1"

    # se individua un Client con carico sopra la soglia stabilita, gli invia attraverso syslog un
    # messaggio col solo testo "STOP"
    LOAD=$(snmpget -v2c -c public 10.100.2.5 1.3.6.1.4.1.2021.10.1.3.1 | awk -F'STRING: ' '{ print $2 }' | cut -d'.' -f1 ) 
    # solo la parte intera per semplicità

    test $LOAD -gt $SOGLIA && logger -p local5.info -n $IP "STOP"

}

# interroga via SNMP in parallelo tutti i Client potenzialmente attivi
# hanno ip 10.100.2.1 - 10.100.7.254
for LAST1 in {2..7} ; do
    for LAST2 in {1..254} ; do
        ask_client "10.100.${LAST1}.${LAST2}" &
    done

done

wait