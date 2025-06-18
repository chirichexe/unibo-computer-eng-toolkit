#!/bin/bash

IP=172.16.0.1

# Chiede interattivamente uno username, d'ora in poi indicato come USERNAME, e controlla se USERNAME esiste su LDAP
while read USERNAME  ; do

    LDAP_QUERY=$(ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis")

    if ! [[ $LDAP_QUERY =~ "uid=$USERNAME" ]] ; then
    # CASO A - USERNAME non esiste su LDAP
    
    # lo script verifica se USERNAME è composto solo da lettere minuscole, e di lunghezza compresa tra 4 e 8 caratteri; 
    # se questi requisiti non sono verificati, termina visualizzando un errore, altrimenti prosegue

        if ! [[ "$USERNAME" =~ ^[a-z]+$ ]] ; then
            echo "l'username deve avere solo caratteri minuscoli!"
            exit 1
        fi

        # genera una password casuale di 8 caratteri alfanumerici e la visualizza

        PASSWORD=$(shuf -i 100000-999999 -n 1)
        echo $PASSWORD

        # Inserisce nella directory LDAP l’utente e un gruppo omonimo da usare come suo gruppo principale. 
        # La shell dell’utente deve essere impostata a /bin/bash, e la home a /home/USERNAME
        # l'esecuzione procede come da CASO B

        LAST_UID=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub | grep -E "uidNumber" | cut -f2 -d' ' | sort -nr | head -1)
        LAST_UID=${LAST_UID:-9999}
        (( LAST_UID++ ))

        LAST_GID=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub | grep -E "gidNumber" | cut -f2 -d' ' | sort -nr | head -1)
        LAST_GID=${LAST_GID:-9999}
        (( LAST_GID++ ))

# aggiunta gruppo
ldapadd -x -H ldap://$IP/ -D "cn=admin,dc=labammsis" -w "gennaio.marzo" <<LDIF
dn: cn=$USERNAME,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $USERNAME
gidNumber: $LAST_GID
LDIF

    ldapadd -x -H ldap://$IP/ -D "cn=admin,dc=labammsis" -w "gennaio.marzo" <<LDIF
dn: uid=$USERNAME,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $USERNAME
cn: $USERNAME
sn: $USERNAME
mail: $USERNAME@$USERNAME.com
uid: $USERNAME
uidNumber: $LAST_UID
gidNumber: $LAST_GID
homeDirectory: /home/$USERNAME
loginShell: /bin/bash
gecos:$USERNAME
userPassword: {crypt}x
LDIF


    ldappasswd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -S "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD"

    fi

    # CASO B - USERNAME esiste su LDAP


    # lo script verifica se esiste la home dell'utente USERNAME.
    if ! [[ -d "/home/$USERNAME" ]] ; then
        
        # se non esiste, invia al Manager via syslog, con etichetta local1.notice, la stringa _NEW_USERNAME_IP_ essendo 
        HOST_IP=$(hostname -I | awk '{ print $2 }')
        
        # IP l’indirizzo della workstation su eth1.
        logger -p local1.notice -n $IP "_NEW_${USERNAME}_${HOST_IP}_"
    
    fi
    
    # lo script controlla ogni 2 secondi se la home è statta creata; se dopo 30 secondi non è ancora comparsa, 
    # termina visualizzando un errore, altrimenti prosegue eseguendo il comando /usr/bin/su - USERNAME
    COUNT=0
    while sleep 2 ; do
        (( COUNT += 1 ))

        [[ $COUNT -eq 2 ]] && { echo "errore nella creazione della home"; exit 1; }

        if [[ -d "/home/$USERNAME" ]] ; then
            /usr/bin/su - $USERNAME
        fi

    done

done