#!bin/bash

# funzioni -------------------------------------------------

function funzione() {
    local NAME="$1"
    local LAST="$2"
    echo "Funzione eseguita per $NAME su 10.11.11.$LAST"
}

# controllo argomenti --------------------------------------

if [$# -ne 3 ] ; then
    echo "usage: $0 <file> <word> <integer>"
    exit 1
fi

if ! [[ -r "$1" ]] then
	echo "missing argument or unreadable file"
	exit 1
fi

if ! [[ "$2" =~ ^[a-zA-Z]+$ ]] ; then
    echo "second argument must be a word"
    exit 1
fi

if ! [[ "$3" =~ ^[0-9]+$ ]] ; then
    echo "third argument must be an integer"
    exit 1
fi

# funzioni utili ------------------------------------------

IP=$(hostname -I | awk '{print $1}')

# LDAP
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "dc=labammsis" -s sub # Search entire LDAP directory
ldapdelete -x -H ldapi:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=davide,ou=People,dc=labammsis" # Delete user 'davide' from LDAP
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" "(objectClass=posixAccount)" # Search for all posixAccount objects
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" "(uid=dave)" # Search for user 'dave' in LDAP
ldappasswd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -S "uid=filo,ou=People,dc=labammsis" # Set password for user 'filo' in LDAP

echo "dn: uid=dave,ou=People,dc=labammsis
changetype: modify
replace: mail
mail: nuovo.indirizzo@unibo.it" >> change_mail.ldif

ldapmodify -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -f change_mail.ldif

# SNMP
snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"$COMANDO_REMOTO\"
snmpwalk -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull


# ----------------------------------------------------------

# uso di regular expression

# ----------------------------------------------------------

# lettura con separatore "custom"
cat $FILE | grep -Ev '^#' | while IFS=\; read USERNAME USERID PASSWORD ; do


    # aggiunta utente ldap

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

	# aggiunta gruppo

	ldapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" <<LDIF
dn: cn=$USERNAME,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $USERNAME
gidNumber: $USERID
LDIF

    # aggiunta password all'utente

	ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD"

	# generazione chiave ssh
	# se esiste: rm -f "${PATH_KEYS}/$USERNAME" "${PATH_KEYS}/$USERNAME.pub"
	ssh-keygen -t rsa -f ${PATH_KEYS}/$USERNAME -N ''

	# logging
	for LAST in {100..120} ; do
		logger -p local1.info -n 10.11.11.$LAST "$USERNAME"
		logger -p local1.info -n 10.22.22.$LAST "$USERNAME"
	done

    # esecuzione funziomi in parallelo
    for LAST in {100..120} ; do
        funzione "$USERNAME" "$LAST" &
    done

    wait # attende la fine di tutte le funzioni in parallelo

	# aggiunta comandi snmpd (operazione con sudo)
	#echo "extend-sh ${USERNAME}_PUB /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/${USERNAME}.pub" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null
	#echo "extend-sh ${USERNAME}_PRIV /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/$USERNAME" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null

	sudo sh -c "echo extend-sh ${NAME}_PUB /usr/bin/sudo -u vagrant /usr/bin/cat /home/vagrant/keys/${NAME}.priv >> /etc/snmp/snmpd.conf > /dev/null"

done

# restart snmpd once for all    
sudo /usr/bin/systemctl restart snmpd.service
