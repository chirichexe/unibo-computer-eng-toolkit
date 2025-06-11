#!/bin/bash



test $# != 1 && { echo "usage: $0 [nome]"; exit 1; }

NAME="$1"
IP=10.0.2.15

LAST_UID=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub | grep -E "uidNumber" | cut -f2 -d' ' | sort -nr | head -1)
LAST_UID=${LAST_UID:-9999}
(( LAST_UID++ ))

LAST_GID=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub | grep -E "gidNumber" | cut -f2 -d' ' | sort -nr | head -1)
LAST_GID=${LAST_GID:-9999}
(( LAST_GID++ ))

cat > file.ldif <<EOF
dn: uid=$NAME,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $NAME
cn: $NAME
sn: $NAME
mail: $NAME@unibo.it
uid: $NAME
uidNumber: $LAST_UID
gidNumber: $LAST_GID
homeDirectory: /home/$NAME
loginShell: /bin/bash
gecos: $NAME
userPassword: password123

dn: cn=$NAME,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $NAME
gidNumber: $LAST_GID
EOF

if ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -f file.ldif; then
  echo "Utente $NAME aggiunto con successo"
else
  echo "Errore durante ldapadd"
fi

rm -f file.ldif
