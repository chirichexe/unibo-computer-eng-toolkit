#!/bin/bash

# 1. Aggiunge "contrib non-free" alla fine di ogni riga che inizia con "deb" in /etc/apt/sources.list
echo "Modifica /etc/apt/sources.list per aggiungere 'contrib non-free'..."
sudo sed -i '/^deb / s/$/ contrib non-free/' /etc/apt/sources.list

# 2. Aggiorna i pacchetti e installa snmp e snmp-mibs-downloader
echo "Aggiornamento dei pacchetti e installazione di snmp e snmp-mibs-downloader..."
sudo apt update && sudo apt install -y snmp snmp-mibs-downloader

# 3. Commenta la riga con "mibs :" nel file /etc/snmp/snmp.conf
echo "Modifica /etc/snmp/snmp.conf per commentare la linea 'mibs :'..."
sudo sed -i 's/^mibs :/# mibs :/g' /etc/snmp/snmp.conf

echo "Script completato."
