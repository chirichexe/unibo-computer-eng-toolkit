#!/bin/bash

test $# != 1 && { echo "usage: $0 [filename]"; exit 1; }

FILENAME="$1"
IP=10.22.22.1

# scorro il testo escludendo le righe con #
cat $FILENAME | grep -vE '^#' | while read line ; do

  # prendo i parametri separati da ;
  NAME=$(echo $line | cut -f1 -d';' )
  ID=$(echo $line | cut -f2 -d';' )
  PASSWORD=$(echo $line | cut -f3 -d';' )

# importo l'utente su ldif
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
uidNumber: $ID
gidNumber: $ID
homeDirectory: /home/$NAME
loginShell: /bin/bash
gecos: $NAME
userPassword: $PASSWORD

dn: cn=$NAME,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
cn: $NAME
gidNumber: $ID
EOF

  # controllo se l'utente esiste già
  if ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub "(uid=$NAME)" | grep -q "dn: uid=$NAME,ou=People,dc=labammsis"; then
    ldapdelete -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ "uid=$NAME,ou=People,dc=labammsis"
    ldapdelete -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ "cn=$NAME,ou=Groups,dc=labammsis"
  fi

  # aggiungo l'utente al server LDAP
  if ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -f file.ldif; then

    # invio l'username attraverso syslog a tutti gli ip disponibili
    for i in {100..120} ; do
      logger -p local1.info -n 10.11.11.$i "$NAME"
      logger -p local1.info -n 10.22.22.$i "$NAME"

    done

    # creo la home dell'utente
    test -d /home/vagrant/keys || mkdir -p /home/vagrant/keys

    # genero la chiave dell'utente
    ssh-keygen -t rsa -b 2048 -f /home/vagrant/keys/$NAME -N ""

    # configuro il server snmp
    sudo sh -c echo "extend-sh ${NAME}_priv /bin/cat /home/vagrant/keys/${NAME}.priv" >> /etc/snmp/snmpd.conf
    sudo sh -c echo "extend-sh ${NAME}_pub /bin/cat /home/vagrant/keys/${NAME}.pub" >> /etc/snmp/snmpd.conf

  else
    echo "Errore durante ldapadd"
  fi

  rm -f file.ldif

  fi

done