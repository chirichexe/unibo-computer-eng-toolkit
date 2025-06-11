#!/bin/bash

# Script per configurare il proxy su VM dei laboratori

read -p "Inserisci il numero del laboratorio (es. 3 per LAB3): " LAB_NUM

# Calcola la parte dell'indirizzo IP in base al laboratorio
if ! [[ "$LAB_NUM" =~ ^[0-9]$ ]]; then
  echo "Numero del laboratorio non valido. Inserire una sola cifra (es. 3)."
  exit 1
fi

IP_SUFFIX="12${LAB_NUM}"
PROXY_URL="http://192.168.${IP_SUFFIX}.249:8080"

echo "Configurazione del proxy a ${PROXY_URL}"

# Scrive il file di configurazione APT
APT_CONF_FILE="/etc/apt/apt.conf.d/proxy.conf"
echo "Acquire::http::Proxy \"${PROXY_URL}/\";" | sudo tee $APT_CONF_FILE > /dev/null
echo "Acquire::https::Proxy \"${PROXY_URL}/\";" | sudo tee -a $APT_CONF_FILE > /dev/null
echo "File $APT_CONF_FILE aggiornato."

# Aggiunge le variabili d'ambiente al file .bashrc dell'utente
BASHRC="$HOME/.bashrc"
{
  echo ""
  echo "# Proxy per laboratorio"
  echo "export HTTP_PROXY=\"${PROXY_URL}\""
  echo "export HTTPS_PROXY=\"${PROXY_URL}\""
} >> "$BASHRC"

echo "Variabili d'ambiente aggiunte a $BASHRC."
echo "Per applicarle subito, esegui: source ~/.bashrc"
