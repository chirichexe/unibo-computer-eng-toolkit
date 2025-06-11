#!/bin/bash

IP=10.2.2.1
BASE_DN="ou=People,dc=labammsis"
BIND_DN="cn=admin,dc=labammsis"
PASSWORD="gennaio.marzo"

UIDS=$(ldapsearch -x -D "$BIND_DN" -w "$PASSWORD" -H ldap://$IP/ -b "$BASE_DN" "(objectClass=posixAccount)" uid | grep '^uid: ' | awk '{ print $2 }')

for uid in $UIDS; do
    echo "uid trovato: $uid"

    user_info=$(ldapsearch -x -D "$BIND_DN" -w "$PASSWORD" -H ldap://$IP/ -b "$BASE_DN" "(uid=$uid)")
    
    cn=$(echo "$user_info" | grep '^cn: ' | awk '{ print $2 }')

    if test -z $cn ; then
        read -p "inserisci un cn per $uid: " input
        cn=$input
    fi

    sn=$(echo "$user_info" | grep '^sn: ' | awk '{ print $2 }')

    if test -z $sn ; then
        read -p "inserisci un sn per $uid: " input
        sn=$input
    fi
    
    mail=$(echo "$user_info" | grep '^mail: ' | awk '{ print $2 }')

    if test -z $mail ; then
        read -p "inserisci una mail per $uid: " input
        mail=$input
    fi

    new_gecos="${cn}-${sn}-${mail}"

    echo "dn: uid=$uid,$BASE_DN
changetype: modify
replace: gecos
gecos: $new_gecos
" > change_gecos.ldif

    ldapmodify -x -D "$BIND_DN" -w "$PASSWORD" -H ldap://$IP/ -f change_gecos.ldif

    rm -f change_gecos.ldif
done
