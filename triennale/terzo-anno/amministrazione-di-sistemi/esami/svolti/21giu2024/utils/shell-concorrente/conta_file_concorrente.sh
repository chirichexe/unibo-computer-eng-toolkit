#!/bin/bash
function testd() {
	test -d "$1" && return 0
        #si potrebbe essere più precisi testando diversi tipi di errore 
        #es. non esiste, esiste ma non è directory, ...
	echo "Il parametro non è una directory"
	exit 1
}
function conta() {
	find "$1" -type f 2>/dev/null | wc -l
}
testd "$1"
testd "$2"

FA=$(mktemp)
FB=$(mktemp)
# file temporanei: sano usare il tool che li crea senza rischi di 
# omonimia o altri problemi di sicurezza es. corse critiche 

conta "$1" > "$FA" &
conta "$2" > "$FB" &
# notare la necessità di due file diversi: processi concorrenti 
# non possono scrivere sullo stesso file senza interferenza
# a meno di implementare complessi meccanismi di sincronizzazione
# ... ma il filesystem lo fa gratis

wait

CA=$(cat "$FA")
CB=$(cat "$FB")

if [[ $CA -gt $CB ]] ; then
	echo "la directory $1 contiene piu' file ($CA) della directory $2 ($CB)"
elif [[ $CA -lt $CB ]] ; then 
	echo "la directory $2  ($CB) contiene piu' file della directory $1 ($CA)"
else
	echo "le directory $1 e $2 contengono lo stesso numero di file ($CA)"
fi

rm -f "$FA" "$FB"
# importante fare pulizia
