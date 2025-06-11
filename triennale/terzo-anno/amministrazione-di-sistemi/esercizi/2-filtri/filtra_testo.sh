#!/bin/bash

echo $@ | grep -E "val" | cut -f2 -d' ' | sort -nr | head -1

# grep -E "stringa", -E abilita regex estese
# Scopo: filtra solo le righe che contengono gidNumber

# cut -f2 -d' '
# Scopo: filtra l'output prendendo il secondo campo
# usand ' ' come delimitatore

# sort -nr
# le ordina in ordne descrescente numerico

# head -1
# prende solo la prima (numero piu alto)

# ===========================================================
#
# Alternativa awk
# | awk '/^gidNumber:/ {print $2}' | sort -nr | head -1
#
# ===========================================================
