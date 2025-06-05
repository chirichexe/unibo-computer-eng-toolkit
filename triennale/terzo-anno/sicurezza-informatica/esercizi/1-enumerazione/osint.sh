#!/bin/bash

# === Funzioni comuni ===

get_ip() {
  echo "[+] Ricerca IP per $1"
  nslookup "$1" | awk '/^Address: / {print $2}'
}

scan_ports() {
  echo "[+] Scansione porte con nmap su $1"
  sudo nmap -Pn -sS -sV "$1"
}

find_subdomains() {
  domain=$1
  echo "[+] Enumerazione subdomini (brute force passiva)"
  # Usa una wordlist semplice, puoi sostituirla con una wordlist esterna più grande
  wordlist=(www mail smtp ftp webmail ns1 ns2 dev test admin api vpn)

  for sub in "${wordlist[@]}"; do
    host "$sub.$domain" > /dev/null && echo "  Trovato: $sub.$domain"
  done
}

get_all_dns_records() {
  echo "[+] Tutti i record DNS per $1"
  for type in A AAAA MX NS TXT SOA CNAME; do
    echo "== Record $type =="
    nslookup -type=$type "$1"
    echo ""
  done
}

whois_info() {
  domain=$1
  echo "[+] Informazioni WHOIS per $domain"
  whois "$domain" | grep -E 'Domain|Registrant|Expiry|Registrar|Organization|Name Server'
}

greenbone_scan() {
  target=$1
  echo "[+] Placeholder: avviare scansione Greenbone per $target (richiede configurazione)"
  echo "  - Accedi a Greenbone e configura una scansione sul target IP o dominio."
}

hydra_test() {
  ip=$1
  echo "[+] Placeholder: test brute-force con Hydra (es. SSH, FTP)"
  echo "  - Esempio: hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://$ip"
}

# === Analisi ulis.se ===
echo "===================="
echo " Analisi: ulis.se"
echo "===================="
ip_ulis=$(get_ip "ulis.se")
echo "IP associato a ulis.se: $ip_ulis"
find_subdomains "ulis.se"
scan_ports "$ip_ulis"
greenbone_scan "ulis.se"
hydra_test "$ip_ulis"

# === Analisi wildboar.it ===
echo ""
echo "===================="
echo " Analisi: wildboar.it"
echo "===================="
ip_wildboar=$(get_ip "wildboar.it")
echo "IP associato a wildboar.it: $ip_wildboar"
whois_info "wildboar.it"
get_all_dns_records "wildboar.it"
scan_ports "$ip_wildboar"
greenbone_scan "wildboar.it"
hydra_test "$ip_wildboar"
