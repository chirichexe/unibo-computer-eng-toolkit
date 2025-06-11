#!/bin/bash

# Funzione per convertire IP in numero
ip2int() {
  local a b c d
  IFS=. read -r a b c d <<< "$1"
  echo $(( (a << 24) + (b << 16) + (c << 8) + d ))
}

# Funzione per convertire numero in IP
int2ip() {
  local ip=$1
  echo "$(( (ip >> 24) & 255 )).$(( (ip >> 16) & 255 )).$(( (ip >> 8) & 255 )).$(( ip & 255 ))"
}

# Funzione per convertire CIDR in netmask decimale
cidr2mask() {
  local cidr=$1
  local mask=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))
  int2ip $mask
}

# Verifica input
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <ip>/<cidr> (es. 192.168.1.42/24)"
  exit 1
fi

# Estrai IP e CIDR
IFS=/ read ip cidr <<< "$1"

# Calcoli
ip_int=$(ip2int "$ip")
mask_int=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))
net_int=$(( ip_int & mask_int ))
broadcast_int=$(( net_int | (~mask_int & 0xFFFFFFFF) ))
first_ip=$(( net_int + 1 ))
last_ip=$(( broadcast_int - 1 ))
host_count=$(( (1 << (32 - cidr)) - 2 ))

# Stampa risultati
echo "IP Address:      $ip"
echo "Netmask:         $(cidr2mask $cidr) (/ $cidr)"
echo "Network:         $(int2ip $net_int)"
echo "Broadcast:       $(int2ip $broadcast_int)"
echo "Host range:      $(int2ip $first_ip) - $(int2ip $last_ip)"
echo "Usable hosts:    $host_count"
