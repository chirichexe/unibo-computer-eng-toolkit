#!/bin/bash

IP=10.20.20.254
USER=vagrant
REMOTE_PATH=/tmp/dir.backup
LOCALHOST=127.0.0.1

# Se non è presente alcun parametro
if   [ $# -lt 1  ] ; then

    # deve essere fatto un dump in formato LDIF di tutte le entry sotto ou=People,dc=labammsis, e trasferito via
    # SSH/SCP nel file /tmp/dir.backup del Router
    TEMP=$(mktemp)
    
    ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" > $TEMP
    scp $TEMP "${USER}@${IP}:${REMOTE_PATH}"

    rm -rf $TEMP

# Se è presente un parametro di valore "new"
elif [[ $# == 1 && $1 == "new" ]] ; then 

    # devono essere cancellate dalla directory locale tutte le entry sotto ou=People,dc=labammsis, e
    # devono essere sostituite col contenuto del file /tmp/dir.backup del Router, prelevato via SSH/SCP

    ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" | grep "uid: " | awk '{ print $2 }' | 
    while read NAME ; 
        do ldapdelete -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ "uid=$NAME,ou=People,dc=labammsis"
    done

    TEMP=$(mktemp)
    scp "${USER}@${IP}:${REMOTE_PATH}" $TEMP 
    
    ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -f $TEMP

    rm -rf $TEMP

else
    # Se è presente un parametro ma di valore diverso, o più parametri, devono essere loggati via syslog 
    # sul file /var/log/ldap.errors del Router

    logger -p local1.warn -n $IP "$@"

fi