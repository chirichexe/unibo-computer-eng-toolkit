#!/bin/bash

function printerror() {
    # $1: parametro per exit code
    # $2: parametro stringa spe iale
    # $3, 4... parametri successivi stringa da stampare
    
    CODE=$1
    SPECIAL=$2
    shift 2
    
    echo "Parametro speciale: " $SPECIAL
    echo $@
    exit $CODE
}

[[ -z "$1" ]] && printerror 1 RIPROVA "manca parametro"

echo proseguo