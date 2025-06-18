#!/bin/bash

# N.B. Per testare senza eseguire: bash -n script.sh
# Per controllare variabili e tutto (eseguendolo): bash -eux script.sh

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

if ! [[ "$4" =~ ^10\.1\.1\.[0-9]+$ || "$4" =~ ^10\.2\.2\.[0-9]+$ ]]; then
    echo "fourth argument must be a valid IP of the type 10.1.1.x or 10.2.2.x"
    exit 1
fi

# UTILS ---------------------------------------------------
# identità utente (in questo caso l'ip)
IP=$(hostname -I | awk '{print $1}')

# per gli altri check: man test
[ -f "$FILE" ] && echo "File $FILE exists." || echo "File $FILE does not exist."
[ -d "$DIR" ] && echo "Directory $DIR exists." || echo "Directory $DIR does not exist."
[ -x "$FILE" ] && echo "File $FILE is executable." || echo "File $FILE is not executable."
[ -z "$STRING" ] && echo "String is empy."

# manipolazione file temporaneo
TEMP_FILE=$(mktemp)
echo "test" > "$TEMP_FILE"
cat "$TEMP_FILE"
rm -f "$TEMP_FILE"

# find
find "$dir_input" -maxdepth 1 -type f -name "a*" -print # file che iniziano per 'a' nella directory $dir_input
find . -type f -exec grep -H 'setup_lab' {} \; # cerca in tutte le sottodirectory un file che si chiama setup_lab
find . -name "*.socket"    # trova tutti i file di nome .socket

# PERMESSI -------------------------------------------------

sudo chown $NEW_USER:$NEW_GROUP nome_file   # cambia proprietario file
sudo chown :$GROUPNAME /cartella_gruppo     # directory accessibile solo a un gruppo
sudo usermod -g $NEW_GROUP $USERNAME        # cambia gruppo di un utente

# ~/.ssh/authorized_keys         -> 600 (solo lettura/scrittura per l'utente)
# ~/.ssh/                        -> 700 (accesso completo solo all'utente)
# ~/.ssh/id_rsa (chiave privata) -> 600
# ~/.ssh/id_rsa.pub (pubblica)   -> 644
# /home/user/, meglio chmod -R   -> 700

# LDAP -----------------------------------------------------


# Search entire LDAP directory
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "dc=labammsis" -s sub
# Delete user 'davide' from LDAP
ldapdelete -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ "uid=davide,ou=People,dc=labammsis"
# Search for all posixAccount objects
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" "(objectClass=posixAccount)"
# Search for user 'dave' in LDAP
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" "(uid=dave)"
# Set password for user 'filo' in LDAP
ldappasswd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -S "uid=filo,ou=People,dc=labammsis" -s "$PASSWORD"
# Edit the mail value
echo "dn: uid=dave,ou=People,dc=labammsis
changetype: modify
replace: mail
mail: nuovo.indirizzo@unibo.it" >> change_mail.ldif

ldapmodify -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -f change_mail.ldif

# Prende solo gli uid degli utenti
USER_UIDS=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub "(objectClass=posixAccount)" uidNumber | grep -E "uidNumber" | awk '{print $2}')
#oppure
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://$IP/ -b "ou=People,dc=labammsis" | grep "uid: " | awk '{ print $2 }'

# Prende solo i gid dei gruppi
GROUP_GIDS=$(ldapsearch -x -H ldap://$IP/ -b "dc=labammsis" -s sub "(objectClass=posixGroup)" gidNumber | grep -E "gidNumber" | awk '{print $2}')

# calcola gli ultimi uid
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

# aggiunta utente
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

# SNMP -----------------------------------------------------

snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"$COMANDO_REMOTO\"
snmpwalk -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull

# per ottenere solo il campo

snmpget -v 1 -c public $IP NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"test\" | awk -F': ' '{print $2}'


# aggiunta comandi snmpd (operazione con sudo)
echo "extend-sh ${USERNAME}_PUB /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/${USERNAME}.pub" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null
echo "extend-sh ${USERNAME}_PRIV /usr/bin/sudo -u vagrant /usr/bin/cat ${PATH_KEYS}/$USERNAME" | sudo /usr/bin/tee -a /etc/snmp/snmpd.conf > /dev/null

# restart snmpd once for all    
sudo /usr/bin/systemctl restart snmpd.service

# SSH ------------------------------------------------------

# Accesso da Client a Servee:

# Client: ssh-keygen -t rsa -b 4096 , genera la coppia di chiavi

# Server: /home/utente/.ssh/authorized_keys , copia la chiave pubblica nella directory dell'utente
#         ssh-copy-id utente@server
# ! IMPORTANTE ! Va messa solo se non c'è già 
# grep "$PUBKEY" /home/$USERNAME/.ssh/authorized_keys || echo "$PUBKEY" >> /home/$USERNAME/.ssh/authorized_keys

# Client: ssh utente@server , si connette

if [ ! -f ~/.ssh/id_rsa ]; then # Generate SSH key pair if not exists
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ''
fi

ssh-copy-id -i ~/.ssh/id_rsa.pub "user@$IP" # Copy SSH key to remote machine for passwordless login

ssh "user@$IP" "echo 'Remote command executed on $(hostname)'" # Execute remote command on the machine

scp /path/to/local/file "user@$IP:/path/to/remote/destination" # Securely copy a file to the remote machine

scp "user@$IP:/path/to/remote/file" /path/to/local/destination # Securely copy a file from the remote machine

ssh "user@$IP" 'bash -s' < /path/to/local/script.sh # Run a script remotely

ssh root@$IP "tar -xz -C /home/$USER" < /archive/path.tgz
ssh root@$IP " tar -cz -C /home/$USER . " > /archive/path.tgz

# REGEX NOTEVOLI -------------------------------------------

# Check if a string is an IP of the type 10.1.1.x or 10.2.2.x

echo "$STRING" | grep -E '^10\.1\.1\.[0-9]+$|^10\.2\.2\.[0-9]+$' && echo "Valid IP"

echo "$STRING" | grep -F "$SUBSTRING" && echo "Substring found"
# CICLI-----------------------------------------------------

# con -F, evita l'errore se non esiste
tail -F "$LOGFILE" | while read -r LINE; do

    LOGVALUE=$(echo "$LINE" | awk -F"log:" '{print $2}' | )

done

tail -n 1 -F "$LOGFILE" | while read -r LINE; do
    echo "$LINE"
done

# riga nel formato _a_B_c_
tail -f $LOGFILE | while IFS='_' read -r _ TYPE USER IP _ ; do 

done

# lettura con separatore "custom"
cat $FILE | grep -Ev '^#' | while IFS=\; read USERNAME USERID PASSWORD ; do

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

    # lettura fino a quando l'input non è valido
    while true; do
        read -p "Enter a string matching the pattern (e.g., 'abc123'): " INPUT_STRING
        if [[ "$INPUT_STRING" =~ ^[a-zA-Z]+[0-9]+$ ]]; then
            echo "Valid input: $INPUT_STRING"
            break
        else
            echo "Invalid input. Please try again."
        fi
    done

done
