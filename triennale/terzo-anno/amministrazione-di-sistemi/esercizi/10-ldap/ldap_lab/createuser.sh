#!/bin/bash
SERVER=10.1.1.2

echo "$1" | grep -E '^[a-z]+$' || {
	echo invalid username
	exit 1
}


MAXU=$(ldapsearch -x -H ldap://$SERVER/ -b "ou=People,dc=labammsis" -s one | grep -E '^uidNumber' | cut -f2 -d' ' | sort -nr | head -1)
if test "$MAXU" ; then (( MAXU++ )) ; else MAXU=10000 ; fi

MAXG=$(ldapsearch -x -H ldap://$SERVER/ -b "ou=Groups,dc=labammsis" -s one | grep -E '^gidNumber' | cut -f2 -d' ' | sort -nr | head -1)
if test "$MAXG" ; then (( MAXG++ )) ; else MAXG=10000 ; fi
(( MAXG++ ))

echo "dn: uid=$1,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $1
cn: $1
sn: $1
mail: $1@example.com
uid: $1
uidNumber: $MAXU
gidNumber: $MAXG
homeDirectory: /home/$1
loginShell: /bin/bash
gecos: $1
userPassword: {crypt}x

dn: cn=$1,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $1
gidNumber: $MAXG" | ldapadd -c -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$SERVER/

