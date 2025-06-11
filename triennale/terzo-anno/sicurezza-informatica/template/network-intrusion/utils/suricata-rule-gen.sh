#!/bin/bash

read -p "Inserisci il tipo di azione (drop, alert, pass, reject, log) [default: alert]: " azione
azione=${azione:-alert}
read -p "Inserisci il protocollo [ ip(all/any), tcp, udp, icmp ]: " protocollo
read -p "Inserisci l'indirizzo IP sorgente (es. 10.10.0.0/16 o any): " ip_sorgente
read -p "Inserisci la porta sorgente (es. any o specifica): " porta_sorgente
read -p "Inserisci la direzione (es. -> o <>) [default ->]: " direction
direction=${direction:-->}
read -p "Inserisci l'indirizzo IP destinazione (es. 10.10.10.10 o any): " ip_destinazione
read -p "Inserisci la porta destinazione (es. 23 o any): " porta_destinazione
read -p "Inserisci il messaggio della regola (es. \"Flag Detected\"): " msg
read -p "Inserisci il contenuto da cercare (es. \"FLAG\"): " content
read -p "Inserisci l'SID della regola [default: 10000001]: " sid
sid=${sid:-10000001}
read -p "Inserisci la revisione della regola [default: 1]: " rev
rev=${rev:-1}

regola="$azione $protocollo $ip_sorgente $porta_sorgente $direction $ip_destinazione $porta_destinazione (msg:\"$msg\"; content:\"$content\"; sid:$sid; rev:$rev;)"

echo -e "\nLa tua regola Suricata è:"
echo $regola
