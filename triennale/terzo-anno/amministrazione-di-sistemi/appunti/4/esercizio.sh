
#!/bin/bash

function printguests() {
    # Stampa tutti i nome e cognome
    CODE=$1
    shift 1
    for i in $@ ; do echo $i; done
    exit $CODE
}

printguests 1 $@
