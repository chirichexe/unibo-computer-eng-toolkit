#!/bin/bash

# Funzione per mostrare informazioni sul file
file_info() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        echo "Errore: il file '$file' non esiste."
        return 1
    fi

    echo "===================================="
    echo "Informazioni per: $file"
    echo "------------------------------------"

    perms=$(stat -c "%A (%a)" "$file")
    echo "Permessi: $perms"

    owner=$(stat -c "%U" "$file")
    group=$(stat -c "%G" "$file")
    echo "Proprietario: $owner"
    echo "Gruppo: $group"

    atime=$(stat -c "%x" "$file")
    mtime=$(stat -c "%y" "$file")
    ctime=$(stat -c "%z" "$file")
    echo "Ultimo accesso (atime): $atime"
    echo "Ultima modifica contenuto (mtime): $mtime"
    echo "Ultima modifica metadati (ctime): $ctime"

    size=$(stat -c "%s" "$file")
    echo "Dimensione: $size byte"
    echo
}

# Controllo argomento
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <directory>"
    exit 1
fi

DIR="$1"

if [[ ! -d "$DIR" ]]; then
    echo "Errore: '$DIR' non è una directory"
    exit 2
fi

# Scorri tutti i file del sottoalbero
find "$DIR" -type f | while read -r file; do
    file_info "$file"
done
