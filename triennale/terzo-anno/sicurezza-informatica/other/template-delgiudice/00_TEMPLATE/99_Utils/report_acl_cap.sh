#!/bin/bash

# Controllare se lo script è stato eseguito con privilegi di root
if [ "$(id -u)" -ne 0 ]; then
  echo "Questo script deve essere eseguito con sudo o come root."
  exit 1
fi

# Loop infinito per chiedere all'utente di inserire percorsi di comandi
while true; do
    # Chiedere all'utente di inserire un percorso di comando
    read -p $'\nInserisci il percorso del comando o del file da esaminare (ENTER per terminare):\n' percorso
    
    # Controllare se l'utente ha premuto solo ENTER per terminare il loop
    if [[ -z "$percorso_comando" ]]; then
        echo -e "\nTerminazione del programma."
        break
    fi
    
    # Controllare se il percorso del comando esiste
    if [[ -f "$percorso_comando" ]]; then


        # Eseguire getfacl sul percorso del comando
        echo "Eseguo: getfacl $percorso_comando"
        getfacl "$percorso_comando"
        
        # Eseguire getcap -r sul percorso del comando
        echo "Eseguo: getcap -r $percorso_comando"
        getcap -r "$percorso_comando"
        
        # Controllare se il comando ha capabilities
        if [[ -z $(getcap "$percorso_comando") ]]; then
            echo -e "Il comando $percorso_comando non ha capabilities."
        fi
        
        # Controllare se il percorso del comando è /etc/passwd o /etc/shadow
        if [[ "$percorso_comando" == "/etc/passwd" || "$percorso_comando" == "/etc/shadow" ]]; then
            echo "Eseguo: diff "$percorso_comando" "$percorso_comando"-"
            diff "$percorso_comando" "$percorso_comando"-
        fi
    else
        echo -e "\nIl percorso $percorso_comando non esiste."
    fi
done