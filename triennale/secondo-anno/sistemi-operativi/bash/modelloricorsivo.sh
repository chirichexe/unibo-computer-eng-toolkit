#!/bin/bash

#Controllo argomenti
#dummy: filtro ricorsivamente solo i file nella directory "dir" (e sotto) che contengono l'estenisone ".str"
#esame $str $dir $int $fileabs
if [[ $# -lt 4 ]] ; then
    echo "Errore: numero di argomenti non corretto"
    exit 1
fi

#Test formattazione stringa, deve iniziare per .
case "$1" in
	.*)
	;;
	*)
	echo "Errore: la stringa di estensione deve iniziare per . "
	exit 1
	;;
esac
#IN ALTERNATIVA, per controllare che il numero di caratteri sia giusto
if [[ ! "$1" = .??? ]] ; then
	echo "$1 deve essere un'estensione"
	exit 1
fi

#Test esistenza directory
if [ ! -d "$2" ] ; then
	echo "Errore: la directory $2 non esiste"
	exit 1
fi

#Controllo intero
if [[ ! "$3" =~ ^-?[0-9]+$ ]]; then
	echo "$3 deve essere un intero"
	exit 1
fi

#Controllo che un path sia assoluto
if [[ ! "$4" = /* ]] ; then
  echo "Il percorso di $4 non è assoluto"
  exit 1
fi

#Controllo che il file esista
if [[ ! -f "$4" ]] ; then
  echo "Il file $4 non esiste"
  exit 1
fi

#redirezione output nel file "report" situato sulla home, prima sovrascritto, poi aggiunte cose in "append"
> $HOME/report
echo Cerco files con estensione $1 >> $HOME/report

#Scorrere un numero indefinito di parametri
#for (( i=4; i<=$#; i++ )); do
#    eval param=\${$i}
#    echo $param
#done

#OPPURE 

#shift 3
#for arg in $@; do
#  echo $arg
#done

#switch a seconda di come "entro" nella ricorsione 
case "$0" in
    /*) 
    dir_name=`dirname $0`
    recursive_command="$dir_name"/recursion.sh
    ;;
    */*)
    dir_name=`dirname $0`
    recursive_command="`pwd`/$dir_name/recursion.sh"
    ;;
    *)
    recursive_command=recursion.sh
    ;;
esac

echo "Inizio recorsione sulla directory $4"
"$recursive_command" "$1" "$2"