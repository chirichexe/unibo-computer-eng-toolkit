#!/bin/bash

# script per eseguire un comando una sola volta
# se già in esecuzione, non avviare una nuova istanza

# comando e argomenti
cmd="$*"

# cerca processi che non siano questo script e che corrispondano esattamente
if pgrep -f -- "$cmd" | grep -v "$$" > /dev/null; then
  echo "istanza già in esecuzione: $cmd"
  # pkill -f -- "$cmd"
  exit 1
fi

echo "eseguo: $cmd"
$cmd &
