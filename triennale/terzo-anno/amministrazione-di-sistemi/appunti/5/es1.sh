#!/bin/bash
handle_signal(){
    echo "segnale ricevuto"
}

function printError() {
    echo "manca parametro";
    exit 1;
}

function countLine() {
    echo "Analizzo file $1";
    count=tail -f $1 | wc -l
    echo "contate: $count"
    exit 0;
}

[[ -z "$1" ]] && printError

countLine $1