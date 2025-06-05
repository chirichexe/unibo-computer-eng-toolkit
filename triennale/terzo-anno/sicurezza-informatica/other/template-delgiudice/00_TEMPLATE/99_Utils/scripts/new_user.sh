#!/bin/bash

echo "Creazione di una nuova entry per /etc/passwd e /etc/shadow"

# Chiedere i dettagli dell'utente
read -p "Inserisci il nome utente: " username
read -p "Inserisci password (default: x): " pswd
passwd=${passwd:-x}
read -p "Inserisci l'UID (User ID): " uid
read -p "Inserisci il GID (Group ID): " gid
read -p "Inserisci il nome completo/commento: " comment
read -p "Inserisci il percorso della home directory: " home
read -p "Inserisci il percorso della shell di login: " shell

# Generare l'entry per /etc/passwd
entry_passwd="${username}:${pswd}:${uid}:${gid}:${comment}:${home}:${shell}"
echo "Entry passwd:"
echo $entry_passwd

# Chiedere la password per l'entry di /etc/shadow
read -p "Inserisci la password per l'utente (default: vuota): " password
password=${password:-}

# Generare il salt per la password
if [[ -n $password ]]; then
    # Generare il salt per la password
    echo "Calcolo del salt con: openssl rand -base64 32"
    salt=$(openssl rand -base64 32)

    # Codificare la password con il salt
    echo "Calcolo della password con: openssl passwd -6 -salt \"$salt\" \"$password\""
    encrypted_password=$(openssl passwd -6 -salt "$salt" "$password")
else
    encrypted_password=""
fi


entry_shadow="${username}:${encrypted_password}:::::::"
echo "Entry shadow:"
echo $entry_shadow
