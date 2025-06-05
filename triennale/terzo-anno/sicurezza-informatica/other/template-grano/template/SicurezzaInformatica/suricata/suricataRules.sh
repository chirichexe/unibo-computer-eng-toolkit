#Una regola suricata ha la seguente struttura:

# - Azione : 
#   - drop: scarta il pacchetto
#   - alert: invia un alert
#   - pass: lascia passare il pacchetto
#   - reject: scarta il pacchetto e invia un alert
#   - log: registra il pacchetto

# - Intestazione: protocollo sorgente porta direzione destinazione porta -> protocollo destinazione porta destinazione
# Protocollo : ip(all,any), tcp, udp, icmp
# Sorgente/Destinazione : : IPv4, IPv6, $HOME_NET, $EXTERNAL_NET
# Direzione : source -> destination , source <> destination (bidirezionale)
# Porta : numero di porta o any


# - Opzioni: sono tra parentesi tonde e possono essere:
#   - msg: messaggio di alert
#   - sid: id della regola
#   - rev: versione della regola
#   - classtype: classificazione della regola
#   - priority: priorità della regola
#   - metadata: informazioni aggiuntive
#   - flow: direzione del flusso di traffico
#   - content: contenuto del pacchetto


#Esempi

#Regola alert per tutto il traffico ICMP solo in entrata sul $HOME_NET
alert icmp any any -> $HOME_NET any (msg:"ICMP traffic detected"; sid:1000001;)

#Scrivere una (o più) regola suricata in modalità alert per qualsiasi richiesta a evilcorp.com. Nota bene NON è possibile utilizzare il protocollo http o la porta 80 per creare questa regola.
alert ip any any -> evilcorp.com any (msg:"Request to evilcorp.com detected"; content:"evilcorp.com"; sid:1000002;)
alert dns any any -> evilcorp.com any (msg:"Request to evilcorp.com detected"; content:"evilcorp.com"; sid:1000003;)