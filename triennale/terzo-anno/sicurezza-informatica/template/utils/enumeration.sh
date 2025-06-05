#/!bin/bash

# lsof -i -n | egrep 'COMMAND|LISTEN|UDP'

#netstat mostra lo stato delle socket Unix e di rete
#– di default, già connesse a un altro endpoint
# opzione -l : listening
# opzione -a : entrambe le categorie
#– altre opzioni utili
# -p processo in ascolto
# -n output numerico
# -t tcp socket
# -u udp socket

#!/bin/bash
#
# enumeration.sh - Libreria di comandi per l'enumerazione di un dominio
# Uso: ./enumeration.sh <dominio>
# Lo script raccoglie informazioni su:
#   - IP del dominio e range IP associati
#   - Lista di tutti i subdomain
#   - Altri hostnames associati
#   - Informazioni WHOIS (proprietario, scadenza, provider, ecc.)
#   - Tutti i record DNS del dominio
#
# Requisiti:
#   - whois
#   - dig (da BIND oppure dnsutils)
#   - nslookup (di solito incluso in dnsutils)
#   - nmap
#   - (opzionale) strumenti di enumeration come amass o sublist3r per subdomain
#
# ----------------------------------------------------------------------
# DESCRIZIONE RAPIDA DEGLI STRUMENTI: nslookup e nmap
#
# nslookup:
#   Scopo: Risolvere nomi a host e interrogare direttamente server DNS.
#   Casi d'uso:
#     - Recuperare record A/AAAA:
#         nslookup esempio.com
#     - Specificare un server DNS diverso:
#         nslookup esempio.com 8.8.8.8
#     - Ottenere record MX:
#         nslookup -query=MX esempio.com
#     - Modalità interattiva per più query:
#         nslookup
#         > server 8.8.4.4
#         > set query=TXT
#         > esempio.com
#
# nmap:
#   Scopo: Scanner di porte, servizi e sistemi operativi su host o range.
#   Casi d'uso:
#     - Scansione ping per verificare host attivi:
#         nmap -sn 192.168.1.0/24
#     - Scansione TCP veloce delle 100 porte principali:
#         nmap -F esempio.com
#     - Identificazione di servizi e versioni:
#         nmap -sV esempio.com
#     - Rilevamento sistema operativo:
#         nmap -O esempio.com
#     - Scan completo range porte (richiede privilegi root):
#         sudo nmap -p- esempio.com
#     - Utilizzare script NSE per enumeration DNS:
#         nmap --script dns-brute -p 53 esempio.com
#
# ----------------------------------------------------------------------
# FUNZIONI PRINCIPALI
#

DOMAIN="$1"

if [ -z "$DOMAIN" ]; then
  echo "Uso: $0 <dominio>"
  exit 1
fi

# 1) Ottenere IP del dominio
function get_ip() {
  echo "[*] Indirizzo IP del dominio $DOMAIN:"
  # Interroga DNS per record A e AAAA
  dig +short A "$DOMAIN"
  dig +short AAAA "$DOMAIN"
}

# 2) Ottenere range IP associati al dominio (tramite WHOIS)
function get_ip_range() {
  echo
  echo "[*] Range IP (CIDR) associati al dominio $DOMAIN (WHOIS):"
  # Estrae righe con cidr o netrange da WHOIS
  whois "$DOMAIN" | egrep -i "CIDR|NetRange|inetnum"
}

# 3) Lista di tutti i subdomain
function get_subdomains() {
  echo
  echo "[*] Enumerazione subdomain per $DOMAIN:"
  echo "  - Metodo 1: tentativo di zona AXFR (se permesso)"
  echo "    dig axfr $DOMAIN @ns1.$DOMAIN"
  echo
  echo "  - Metodo 2: utilizzare amass (se installato)"
  if command -v amass &> /dev/null; then
    echo "[+] Esecuzione: amass enum -d $DOMAIN"
    amass enum -d "$DOMAIN"
  else
    echo "[-] amass non trovato. Saltato."
  fi
  echo
  echo "  - Metodo 3: utilizzare sublist3r (se installato)"
  if command -v sublist3r &> /dev/null; then
    echo "[+] Esecuzione: sublist3r -d $DOMAIN -o subdomains.txt"
    sublist3r -d "$DOMAIN" -o subdomains.txt
    echo "    (Risultato salvato in subdomains.txt)"
  else
    echo "[-] sublist3r non trovato. Saltato."
  fi
}

# 4) Altri hostnames associati
function get_other_hostnames() {
  echo
  echo "[*] Altri hostnames associati a $DOMAIN:"
  # Utilizza DIG per interrogare record NS, CNAME, MX, TXT per trovare potenziali host
  echo "  - Record NS:"
  dig +short NS "$DOMAIN"
  echo
  echo "  - Record MX:"
  dig +short MX "$DOMAIN"
  echo
  echo "  - Eventuali CNAME:"
  dig +short CNAME "$DOMAIN"
}

# 5) Tutte le informazioni possibili sul dominio (WHOIS)
function get_whois_info() {
  echo
  echo "[*] Info WHOIS per $DOMAIN:"
  whois "$DOMAIN"
}

# 6) Enumerare TUTTI i record DNS del dominio
function get_all_dns_records() {
  echo
  echo "[*] Tutti i record DNS per $DOMAIN (tramite dig ANY):"
  dig ANY "$DOMAIN" +multiline +noall +answer
}

# ESECUZIONE SEQUENZIALE DELLE FUNZIONI
get_ip
get_ip_range
get_subdomains
get_other_hostnames
get_whois_info
get_all_dns_records

exit 0
