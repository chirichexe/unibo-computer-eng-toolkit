#!/bin/bash

# Lo script deve processare ogni volta che viene avviato tutte le righe in /var/log/newusers.
LOGFILE=/var/log/newusers
ROUTER_IP=10.1.1.1

cat $LOGFILE | awk '{ print $6 }' | while read UTENTE ; do
    
    # Per ogni riga, estrae l'utente, e crea se necessario 
    # la home directory nella forma /home/USERNAME assegnando correttamente tutti i permessi.
    HOME="/home/${UTENTE}"
    mkdir -p $HOME/.ssh

    chown -R $UTENTE:$UTENTE $HOME
    chmod -R 700 $HOME


    HOSTNAME=$(hostname -I | grep -E '^(10\.1\.1\.|10\.2\.2\.)')


    if [[ $HOSTNAME =~ ^10.1.1. ]] ; then 
        # Se lo script rileva di essere in esecuzione su di uno dei Client,
        echo "sono su client..."

        # interroga via SNMP il Router per ottenere le due chiavi e le installa nella posizione/nome standard
        # (/home/USERNAME/.ssh/id_rsa e /home/USERNAME/.ssh/id_rsa.pub)

        # Lato router, USERNAME_PRIV e USERNAME_PUB mi fanno ottenere le chiavi
        # il comando snmp le cerca in /home/vagrant/keys/USERNAME e mi fa il "cat"

        snmpget -v 1 -c public "$ROUTER_IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"${UTENTE}_PRIV\" | tee "$HOME/.ssh/id_rsa" > /dev/null
        chown $UTENTE:$UTENTE "$HOME/.ssh/id_rsa"
        chmod 400 "$HOME/.ssh/id_rsa"
    
        snmpget -v 1 -c public "$ROUTER_IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"${UTENTE}_PUB\" | tee "$HOME/.ssh/id_rsa.pub" > /dev/null
        chown $UTENTE:$UTENTE "$HOME/.ssh/id_rsa.pub"
        chmod 444 "$HOME/.ssh/id_rsa.pub"

    elif [[ $HOSTNAME =~ ^10.2.2. ]] ; then
        # Se lo script rileva di essere in esecuzione su di uno dei Server 
        echo "sono su server..."

        # interroga via SNMP il Router per ottenere la chiave pubblica dell'utente e la installa tra le chiavi 
        # autorizzate all'accesso dell'utente con autenticazione senza password.
        snmpget -v 1 -c public "$ROUTER_IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"${UTENTE}_PUB\" | sudo /usr/bin/tee -a "$HOME/.ssh/authorized_keys" > /dev/null


    fi

done
