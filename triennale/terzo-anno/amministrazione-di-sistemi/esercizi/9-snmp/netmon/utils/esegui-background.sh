#!/bin/bash

STATUS=$(jobs | grep "./$0 $1" | awk '{print $2 }')
echo "stato attuale $STATUS"

if [[ $STATUS == "Running" ]] then
    echo "c'è già un'istanza attiva"
else
    sleep 10
fi
