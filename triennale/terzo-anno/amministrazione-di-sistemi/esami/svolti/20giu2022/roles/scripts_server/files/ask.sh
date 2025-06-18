#!/bin/bash

IP=10.200.1.254

# Chiede interattivamente all'utente quale username vuole scegliere, ripetendo la domanda
#finché l'utente non risponde correttamente: lo username deve essere una stringa composta di
#soli caratteri minuscoli e che non corrisponda a uno già presente in LDAP

USERS=$(ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" | grep -E "^uid: " | cut -d' ' -f2)
GROUPS=$(ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=Groups,dc=labammsis" | grep -E "^cn: " | cut -d' ' -f2)

while true; do
    read -p "Scegli un username valido: " USERNAME
    
    if echo "$USERS" | grep -q "^$USERNAME$"; then
        echo "username già presente, riprova"

    elif ! [[ "$USERNAME" =~ ^[a-z]+$ ]]; then
        echo "soli caratteri minuscoli, riprova"
    
    else
        echo "username scelto: $USERNAME"
        break
    fi

done

# Ricava dalla directory i gruppi disponibili e li mostra all'utente:

echo "gruppi disponibili: $GROUPS"

# Chiede interattivamente all'utente quale gruppo vuole scegliere, ripetendo la domanda finché
# l'utente non risponde con una delle opzioni valide

while true; do
    read -p "Scegli un gruppo valido: " GROUP

    if echo "$GROUPS" | grep -vq "^$GROUP$"; then
        echo "gruppo non presente, riprova"
    else
        echo "gruppo scelto: $GROUP"
        break
    fi
done

# Crea l'account sulla directory, impostando come home /tmp e come shell /bin/bash
# 1. calcolo l'uid del nuovo utente
LAST_UID=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub | grep -E "uidNumber" | cut -f2 -d' ' | sort -nr | head -1)
LAST_UID=${LAST_UID:-9999}
(( LAST_UID++ ))

# 2. aggiungo l'utente
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
gidNumber: $GROUP
homeDirectory: /home/temp
loginShell: /bin/bash
gecos:$USERNAME
userPassword: {crypt}x
LDIF

# Genera una password casuale, numerica, lunga almeno 6 caratteri, la imposta sull'account, e
# la stampa in modo che l'utente sul Client la visualizzi a terminale

PASSWORD=$(cat /dev/urandom| tr -dc '0-9' | fold -w 6 | head -n 1)

echo "La tua password è: $PASSWORD"

ldappasswd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -s "$PASSWORD" "uid=$USERNAME,ou=People,dc=labammsis"
