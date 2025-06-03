#!/bin/bash

function printError() {
    echo "manca parametro";
    exit 1;
}

function handler_stampa() {
    echo "righe: $T"
    T=0
}

[[ -z "$2" ]] && printError

echo ciaoaoaos