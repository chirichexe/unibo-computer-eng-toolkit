#!/bin/bash

#Partendo dallo script che esegue un comando solo se il carico è inferiore a una soglia, e in caso contrario si ri-schedula con at, realizzarne una versione che accetta un ulteriore parametro numerico che rappresenta il numero massimo di tentativi da provare.

#OPZIONALE - Usare getopt (non visto a lezione ma documentato sulle slide) per far sì che il comando abbia la sintassi:

#niceexec.sh MAX_TENTATIVI SOGLIA_CARICO COMANDO_DA_ESEGUIRE  PARAMETRI

# testare se $1 è un numero
THIS=/home/davide/Desktop/uni/las/esercizi/5-monitoraggio/niceexec.sh
num=0

if ! [[ "$1" =~ ^[0-9]+$ ]] ; then
	echo "$1 non è un numero"
	exit 1
fi

# testare se $2 è un numero
if ! [[ "$2" =~ ^[0-9]+$ ]] ; then
	echo "$2 non è un numero"
	exit 1
fi

# $2 deve essere eseguibile, file standard e con path assoluto 
# per evitare problemi con l'environment di atd
if ! [[ -x "$3" && -f "$3" && "$3" =~ ^/ ]] ; then
	echo "$3" non è un eseguibile con path assoluto
	exit 1
fi

# ipotesi semplificativa: solo la parte intera del carico a 1 minuto
# per farlo, devo sapere qual è il delimitatore dei decimali 
# in accordo alla localizzazione attiva: man locale
LOAD=$(uptime | awk -F 'average: ' '{ print $2 }' | cut -f1 -d$(locale decimal_point))
if test $LOAD -lt "$2" && test $num -lt "$1" ; then
	shift 2
	eval "$@"
elif test $num -gt "$1" ; then
	echo "Numero massimo di tentativi ($1) raggiunto. Comando non eseguito."
	exit 1
else
	echo $THIS "$@" | at now +2 seconds
	num=$((num + 1))
fi
