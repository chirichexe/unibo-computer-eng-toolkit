#!/bin/bash

#REDIREZIONE I/O----------------------------------------------------------------------

#ls -l > file
#file conterrà il risultato di ls –l
#sort < file > file2
#Ordina il contenuto di file scrivendo il
#risultato su file2
#echo ciao >> file
#Scrive il testo «ciao» in append su file

#COMANDI COMUNI-----------------------------------------------------------------------

#grep -pattern "hello.txt" con pattern:
    #-i: Esegue una ricerca case-insensitive.
    #-v: Inverte la corrispondenza, restituendo le righe che non contengono il pattern.
    #-n: Mostra il numero di riga di ogni corrispondenza.
    #-r: Esegue una ricerca ricorsiva all'interno di directory e sotto-directory.

#wc -pattern test.txt
    #-l: Conta il numero di linee.
    #-w: Conta il numero di parole.
    #-c: Conta il numero di byte.

#cicli innestati:

#for d in `cat $filedir`
#do
#    if ! test -d $d 
#    then    echo il nome $d non corrisponde a una directory esistente
#    else 
#        for f in $d/* ; do
#            if [ -f "$f" ]; then
#                count=`grep -o $S "$f"|wc -l`
#                if [ $count -gt $M ]; then
#                    dim=`cat "$f" | wc -c`
#                    echo Il file $f contiene $dim caratteri.
#                fi
#            fi
#        done        
#    fi
#done

#--------------------------------------------------------------------------------------

#Test numero dei parametri, se giusto, prendi il primo
if test $# -ne 1
then 
  echo Errore nel numero di parametri
  exit 1
fi

val1="$1"

#Test se il parametro in ingresso è positivo
if ! [[ "$val1" =~ ^[0-9]+$ ]] ; then
  echo $val1 non è un intero positivo
  exit 2
fi

#Prende un parametro in ingresso da standard input
echo Immetti il basename del file da analizzare. Il file deve trovarsi nella tua home 
read Fin

#Controllo se Fin, il parametro preso da standard input, è un basename
case "$Fin" in    
  */*) echo $Fin non è un basename ;;    
  *)  if [ ! -f "$HOME/$Fin" ]; then
        echo $Fin non è un file
        exit 3
      fi
      if [ ! -r "$HOME/$Fin" ]; then
        echo $Fin non è leggibile
        exit 4
      fi
  esac

#Memorizzazione di un'espressione calcolato
dim_byte=`ls -l "$HOME/$Fin" | awk '{print $5}'`
D=`expr $dim_byte / 1024`

if [ $D -gt $val1 ] ; then  #(val1> val2)
#if [ $D -gt $KB ]; then    #(val1< val2)
#if [ $D -gt $KB ]; then    #(val1<=val2)
#if [ $D -gt $KB ]; then    #(val1>=val2)
  echo Maggiore
else
  echo Minore
fi
