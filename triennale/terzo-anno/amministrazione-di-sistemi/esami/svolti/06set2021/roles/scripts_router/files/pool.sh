#!/bin/bash
# Realizzare su router uno script /root/poll.sh che esplori l'intervallo di indirizzi assegnabili ai
# server, ricavando via SNMP il carico di ogni server attivo (si noti che nell'intervallo di indirizzi solo
# alcuni server possono essere attivi e quindi rispondere alla query).
BEST_SERVER_FILE=/tmp/bestserver
touch $BEST_SERVER_FILE

TEMP=$(mktemp)

function trova_server() {
    local IP="$1"

	# Il carico è definito come il numero di linee presenti nel file /var/log/conn.log di un server. Lo script
	# deve memorizzare nel file /tmp/bestserver l'indirizzo del server col carico più basso.
	# la funzione carico snmp fa:
	# /usr/bin/cat /var/log/conn.log | /usr/bin/wc -l

	CARICO=$(snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"carico\" 2>/dev/null | awk '{ print $NF }') &&
	echo "$CARICO $IP" >> "$TEMP"

}

for LAST in {1..254} ; do

	# Lo script deve essere eseguito automaticamente ogni 3 minuti; l'esplorazione deve quindi essere
	# svolta in modo da concludersi in un tempo molto più breve, indipendentemente da quanti server
	# siano raggiungibili nell'intervallo di indirizzi considerato.

	trova_server 10.200.1.$LAST & 	
done

wait

cat $TEMP | sort -nr | tail -1 | awk '{ print $2 }' > $BEST_SERVER_FILE

rm -rf $TEMP