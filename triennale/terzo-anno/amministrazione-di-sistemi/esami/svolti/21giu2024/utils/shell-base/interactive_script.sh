#!/bin/bash

# validazione input: verifica se l'input è un indirizzo IP valido
is_valid() {
    [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1

    IFS='.' read -r -a octets <<< "$1"
    for octet in "${octets[@]}"; do
        if ((octet < 0 || octet > 255)); then
            return 1
        fi
    done
    return 0
}

# ==============================================
while true; do
    read -p "inserisci un valore valido: " input

    if is_valid "$input"; then
        echo "valido: $input"
        break
    else
        echo "invalido, riprova"
    fi
done

# ==============================================
echo "inserisci un valore (Ctrl+C per stoppare):"
while true; do
    read -p "> " user_input
    echo "hai inserito: $user_input"
done
