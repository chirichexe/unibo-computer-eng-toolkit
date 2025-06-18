#!/bin/bash

# Richiede come parametro sulla riga di comando un nome utente, ed eventualmente uno o più
# altri parametri che rappresentano nell'insieme una riga di comando da eseguire in remoto

if [$# -lt 1 ] ; then
    echo "usage: $0 <username> [params...]"
    exit 1
fi

USERNAME=$1

# Ricava l'indirizzo del server più scarico con una query SNMP rivolta a router (che, si
# ricordi, conserva queste informazione nel file /tmp/bestserver)

IP=$(snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"get-best\")

# Avvia una connessione ssh verso tale server a nome dell'utente indicato come primo
# parametro, (eseguendo in remoto il comando specificato dagli altri parametri, se presenti).
shift 1

ssh "${USERNAME}@${IP}" "$@"    

# La password verrà quindi richiesta direttamente dal comando ssh.
