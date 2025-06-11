#!/bin/bash

# Controllo numero argomenti
if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "usage: $0 <u/d> <file> [vm]"
    exit 1
fi

mode="$1"
file="$2"
vm="$3"

# Verifica modalità valida
if [[ "$mode" != "u" && "$mode" != "d" ]]; then
    echo "first argument must be 'u' (upload) or 'd' (download)"
    exit 2
fi

# Gestione configurazione ssh
if [[ -z "$vm" ]]; then
    conf_file="ssh.conf"
    if [[ ! -f "$conf_file" ]]; then
        echo "Generating ssh.conf..."
        vagrant ssh-config > "$conf_file" || { echo "Failed to generate ssh.conf"; exit 4; }
    fi
    target="test-vm"
else
    conf_file="ssh_${vm}.conf"
    echo "Generating $conf_file..."
    vagrant ssh-config "$vm" > "$conf_file" || { echo "Failed to generate $conf_file"; exit 4; }
    target="$vm"
fi

# Esecuzione in base alla modalità
if [[ "$mode" == "u" ]]; then
    if [[ ! -f "$file" ]]; then
        echo "file '$file' does not exist"
        exit 3
    fi
    scp -F "$conf_file" "$file" "$target:~"
else
    scp -F "$conf_file" "$target:~/$file" .
fi
