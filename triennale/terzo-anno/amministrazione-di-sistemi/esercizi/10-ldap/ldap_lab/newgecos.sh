#!/bin/bash

SEARCH="ldapsearch -LLL -x -H ldap://10.1.1.2/"
MODIFY="ldapmodify -x -H ldap://10.1.1.2/ -D cn=admin,dc=labammsis -w gennaio.marzo"
LIST=$(mktemp)

echo Elenco utenti:
$SEARCH -s one -b 'ou=People,dc=labammsis' | grep '^uid: ' | cut -c6- | tee "$LIST"
echo
read -p "Utente da aggiornare? " U
while ! cat "$LIST" | grep -qw "$U" ; do 
	echo "$U non e' un utente valido"
	read -p "Utente da aggiornare? " U
done

DATA=$($SEARCH -s base -b "uid=$U,ou=People,dc=labammsis" | egrep '^(cn|mail): ' | cut -f2 -d:)
echo $DATA

#soluzione un po' brutale: sfrutta la tokenizzazione di $DATA non protetto da apici per fare in modo che le due righe vengano di fatto concatenate

$MODIFY <<ENDOFLDIF
dn: uid=$U,ou=People,dc=labammsis
changetype: modify
replace: gecos
gecos: $DATA
ENDOFLDIF

$SEARCH -s base -b "uid=$U,ou=People,dc=labammsis" 

