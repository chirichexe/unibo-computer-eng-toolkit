#!/bin/bash

USERNAME=''

while true ; do
	read -p "Username: " USERNAME
	[[ "$USERNAME" =~ [^a-z] ]] || {
		echo Solo caratteri minuscoli
		continue
	}

	LDAP_OUTPUT=$(ldapsearch -x -LLL -H "ldap://10.100.1.254/" -b "uid=$USERNAME,ou=Users,dc=labammsis" -s base | grep ^dn: )

	[[ "$LDAP_OUTPUT" ]] && {
		echo Utente già esistente
		continue
	}

	break
done

LDAP_GROUPS=$(ldapsearch -x -LLL -H "ldap://10.100.1.254/" -b "ou=Groups,dc=labammsis" -s one | grep "^cn: " | awk -F 'cn: ' '{ print $2 }')

echo "Gruppi disponibili:"
echo "$LDAP_GROUPS"

GROUP=''
while true ; do
	read -p "Gruppo per l'utente $USERNAME: " GROUP
	echo "$LDAP_GROUPS" | grep -Fxq "$GROUP" && break
	echo "Gruppo non valido"
done

GID_NUMBER=$(ldapsearch -x -LLL -H "ldap://10.100.1.254/" -b "cn=$GROUP,ou=Groups,dc=labammsis" -s base "gidNumber" | awk -F 'gidNumber: ' '{ print $2 }')
UID_NUMBER=$(ldapsearch -x -LLL -H "ldap://10.100.1.254/" -b "ou=People,dc=labammsis" -s one "uidNumber" | awk -F 'uidNumber: ' '{ print $2 }' | sort -nr | head -1)
(( UID_NUMBER++ ))

ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H "ldap://10.100.1.254" <<EOF
dn: uid=$USERNAME,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $USERNAME
cn: $USERNAME
sn: $USERNAME
uid: $USERNAME
uidNumber: $UID_NUMBER
gidNumber: $GID_NUMBER
homeDirectory: /tmp
loginShell: /bin/bash
userPassword: {crypt}x
EOF

[[ "$?" == 0 ]] && {
PASSWORD=$(tr -dc '0-9' < /dev/urandom | head -c 10)
ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD" && 
	echo "utente $USERNAME con $PASSWORD creato con successo"
}
