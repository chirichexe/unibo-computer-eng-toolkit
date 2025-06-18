#!/bin/bash

COMANDO_REMOTO=server_attivo
LDAP_SCRIPT_PATH=/home/vagrant/ldap.sh

# Interroga via SNMP il Router, che deve rispondere col contenuto del proprio file /tmp/server.attivo.
# Il contenuto di tale file consiste nel nome di un server (Server1 o Server2) seguito eventualmente 
# da uno spazio e dalla parola "new"

snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"$COMANDO_REMOTO\" | awk -F'STRING:' '{ print $2 }' | while read S N ; do 

    if [[ $(hostname) == $S ]] ; then

        # Se il risultato ottenuto contiene il nome del server su cui è in esecuzione lo script (Server1 o Server2), 
        # lo script assegna all'interfaccia eth2 l'indirizzo aggiuntivo 10.20.20.20

        sudo ip addr add 10.20.20.20/24 dev eth2 

        # Lancia lo script ldap.sh, passando come parametro la parola "new" se è presente nella risposta SNMP
        [[ $NEW == "new" ]] && $LDAP_SCRIPT_PATH "new"
    else 

        # altrimenti lo script si assicura che l'interfaccia eth2 non detenga l'indirizzo 10.20.20.20
        # deconfigurandolo se necessario.

        ip a show dev eth2 | grep "10.20.20.20" && sudo ip addr del 10.20.20.20/24 dev eth2 >/dev/null

    fi

done
