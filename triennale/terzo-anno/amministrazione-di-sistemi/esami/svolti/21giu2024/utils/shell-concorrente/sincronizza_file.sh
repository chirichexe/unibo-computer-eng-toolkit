#!/bin/bash

[[ $# != 2 ]] && { echo "wrong args"; exit 1; }

DIR1=$1
DIR2=$2

function conta() {
	find "$1" -type f 2>/dev/null | wc -l
}

if test -d $DIR1 && test -d $DIR2 ; then

	FT1=$(mktemp)
	FT2=$(mktemp)

	conta $DIR1 > $FT1 & 
	conta $DIR2 > $FT2 & 

	wait

	RES1=$(cat $FT1)
	RES2=$(cat $FT2)

	echo "Risultati: dir1=$RES1 dir2=$RES2"
	
	rm -f $FT1
	rm -f $FT2

	exit 0
else
	echo "uno dei due non è una directory"
	exit 1
fi

