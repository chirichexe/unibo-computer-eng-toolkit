#!/bin/bash

# Si realizzi uno script che prende come parametri
# - una stringa nel formato facility.priority
# - un nome di file
#
# e configuri automaticamente
# - syslog per loggare i messaggi con l'etichetta specificata sul relativo file
# - cron per mandare ogni 5 minuti l'output del comando uptime a syslog con l'etichetta specificata

# main ---------------------------------------------------
# number of arguments check
if [[ $# -ne 2 ]]; then
    echo "usage: $0 <facility.priority> <filename>"
    exit 1
fi

string="$1"   
filename="$2"

# string check
if [[ "$string" != *.* ]]; then
    echo "wrong parameter 1: usage: $0 <facility.priority> <filename>"
    exit 1
fi

# absolute path file check
if [[ ! "$filename" =~ ^/ ]]; then
    echo "wrong parameter 2: usage: $0 <facility.priority> <filename>"
    exit 2
fi

# configurazione di syslog ------------------------------

# necessaria tabulazione ed echo -e per interpretare i backslash

# così non funziona, poichè il sudo viene eseguito
# solo al comando echo e non alla redirezione. serve
# quindi un file temporaneo

#sudo echo -e "$string\t$filename" > /etc/rsyslog.d/testconf.conf

TEMP=$(mktemp)
echo -e "$string\t$filename" > "$TEMP"
sudo cp "$TEMP" /etc/rsyslog.d/testconf.conf
sudo systemctl restart rsyslog

# test del logger: logger -p local4.info "Ciao dal test rsyslog"

# invio ogni 5 min -------------------------------------

CRONCOMMAND="/usr/bin/uptime | /usr/bin/logger -p $string"  # manda l'output di uptime a logger
crontab -l | grep -Fv "$CRONCOMMAND" > $TEMP # evita di aggiungere duplicati nel crontab
echo "*/1 * * * * $CRONCOMMAND" >> $TEMP # riga da scrivere su crontab
crontab $TEMP # sostituisce il crontab corrente con il contenuto del file temporaneo

rm -rf $TEMP


