#!/bin/bash
 
# Realizzare uno script che individui nel sottoalbero del filesystem passato come 
# parametro tutti i file che rispettano almeno una di queste caratteristiche (ogni 
# punto elenco rappresenta una caratteristica da verificare integralmente):

# sono stati modificati o acceduti nell'ultima settimana
# hanno un qualsiasi bit speciale settato e non sono di proprietà dell'utente root
# sono di tipo text (secondo il comando file), di dimensione inferiore a 100k, e contengono la stringa DOC

# e li archivi in un file di nome backup_DATA,tar.gz

file_analyzer() {
    local file="$1"
    valid=false

    # file acceduti o modificati nell'ultima settimana
    one_week_seconds=$((7 * 24 * 60 * 60))
    if [[ $(stat -c "%Y" "$file") -gt $(( $(date +%s) - one_week_seconds )) ]]; then
        valid=true
    fi

    # file non dell'utente root
    owner=$(stat -c "%U" "$file")
    if [[ ! "$owner" == "root" ]]; then
        valid=true
    fi

    # file di tipo text, dimensione < 100k e contengono la stringa DOC
    max_size=$((100 * 1024))
    if [[ $(file "$file") == *"text"* && $(stat -c "%s" "$file") -lt $max_size && $(grep -q "DOC" "$file" 2>/dev/null) ]]; then
        valid=true
    fi

    if [[ "$valid" == true ]]; then
        tar --append -f backup_$(date +%Y%m%d).tar.gz "$file"
        echo "File archiviato: $file"
    else
        echo "File non archiviato: $file"
    fi
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
find "$DIR" -type f | while IFS= read -r file; do
    file_analyzer "$file"
done
