#!/bin/bash

# Autore: Davide Chirichella
# Matricola: 0001071414

test_parametri() {
    local file="$1"
    local dir="$2"
    local numero="$3"

    # file check
    if [[ ! -f "$file" ]]; then
        echo "wrong parameter: usage: $0 <file> <dir> <int>"
        return 1
    fi

    # directory check
    if [[ ! -d "$dir" ]]; then
        echo "wrong parameter: usage: $0 <file> <dir> <int>"
        return 2
    fi

    # integer check
    if ! [[ "$numero" =~ ^[0-9]+$ ]]; then
        echo "wrong parameter: usage: $0 <file> <dir> <int>"
        return 3
    fi

    return 0
}

# main ---------------------------------------------------
# number of arguments check
if [[ $# -ne 3 ]]; then
    echo "usage: $0 <file> <dir> <int>"
    exit 1
fi

# parameters assignment
file_input="$1"
dir_input="$2"
int_input="$3"

# function call
test_parametri "$file_input" "$dir_input" "$int_input"
esito=$?

# check the result of the function
if [[ $esito -ne 0 ]]; then
    exit $esito
fi

# useful functions -----------------------------------------

# Lista file che iniziano per "a" nella directory data
# Usiamo find per leggere direttamente dal disco senza caricare tutto in RAM
echo "File che iniziano per 'a' nella directory $dir_input:"
find "$dir_input" -maxdepth 1 -type f -name "a*" -print

# end ------------------------------------------------------