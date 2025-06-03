#!/bin/bash

if ! [[ -r "$1" ]]
then
	echo "missing argument or unreadable file"
	exit 1
fi

FILE=$1

PATH_KEYS=/home/vagrant/keys

if [[ ! -e $PATH_KEYS ]]
then
	mkdir $PATH_KEYS
fi

egrep '^[^#][^;]+;[^;]+;[^;]+$' $FILE | while IFS=\; read USERNAME USERID PASSWORD ; do
	# echo $USERNAME $USERID $PASSWORD

	# insert user
    ldapadd -x -H ldapi:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" <<LDIF
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
uidNumber: $USERID
gidNumber: $USERID
homeDirectory: /home/$USERNAME
loginShell: /bin/bash
gecos:$USERNAME
userPassword: {crypt}x
LDIF

	# insert group
	ldapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" <<LDIF
dn: cn=$USERNAME,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $USERNAME
gidNumber: $USERID
LDIF

	ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD"

	# key (first remove if already present)
	rm  -f "${PATH_KEYS}/$USERNAME" "${PATH_KEYS}/$USERNAME.pub"
	ssh-keygen -t rsa -f ${PATH_KEYS}/$USERNAME -N ''

	# syslog
	for LAST in {100..120} ; do
		logger -p local1.info -n 10.11.11.$LAST "$USERNAME"
		logger -p local1.info -n 10.22.22.$LAST "$USERNAME"
	done

	# add command to snmpd
	echo "extend-sh ${USERNAME}_PUB /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/${USERNAME}.pub" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null
	echo "extend-sh ${USERNAME}_PRIV /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/$USERNAME" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null


done

# restart snmpd once for all
sudo /usr/bin/systemctl restart snmpd.service
