#!/bin/bash

echo "== Calcolatore permessi Linux (notazione numerica) =="

# Funzione per calcolare il valore per una categoria
calcola_valore() {
    local tipo=$1
    local valore=0

    echo ""
    echo "Permessi per $tipo:"
    read -p "  - Lettura (r)? [y/n]: " r
    read -p "  - Scrittura (w)? [y/n]: " w
    read -p "  - Esecuzione (x)? [y/n]: " x

    [[ "$r" == [yY] ]] && ((valore+=4))
    [[ "$w" == [yY] ]] && ((valore+=2))
    [[ "$x" == [yY] ]] && ((valore+=1))

    echo $valore
}

# Salva solo il risultato numerico senza stampare le domande più volte
owner=$(calcola_valore "proprietario (owner)")
group=$(calcola_valore "gruppo (group)")
others=$(calcola_valore "altri (others)")

chmod_val="${owner}${group}${others}"

echo ""
echo "Puoi usare: chmod $chmod_val nomefile"