#!/bin/bash

if [ "$#" -lt 2 ]; then
   echo "usage: $0 <dir> <est> ..."
   exit 1
fi

test ! -d "$1" && { echo "directory $1 non esistente"; exit 1; } 

DIRECTORY="$1"

shift 1

for arg in "$@"; do
   find /etc -name "*.$arg" 2>/dev/null | grep -oE "$carg$" | uniq -c 
done

# ========================================================================================================
# Soluzione del prof -------------------------------------------------------------------------------------

ls -R 2>/dev/null |  # elenca tutti i file e le directory. L'opzione -R abilita la ricorsione.
egrep -v '^\..*:$' | # esclude le intestazioni delle directory (linee che terminano con ":") e le dir. nascoste (che iniziano con ".")
grep '\.' |          # filtra solo le linee che contengono un punto (indicativo di un'estensione)
rev |                # inverte le linee, sarà più utile lavorare con le estensioni (file.txt -> txt.elif)
cut -f1 -d. |        # estrae la parte prima del'ultimo punto (l'estensione del file)
rev |                # inverte di nuovo le linee per riportarle alla forma originale 
sort |               # ordina le estensioni in ordine alfabetico
uniq -c |            # conta le occorrenze di ogni estensione (conta i raggruppamenti)
sort -nr |           # ordina in ordine decrescente per frequenza
head -n 5            # mostra le prime 5 righe