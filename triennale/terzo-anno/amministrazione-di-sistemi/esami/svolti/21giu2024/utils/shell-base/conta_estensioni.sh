#!/bin/bash
# ciclo principale - iterazione sulla cartella corrente

test -x $1 || { echo "Directory non accessibile"; exit 1; }


function esploraDirectoryCorrente() {

for filename in *
do
   if test -d "$filename" ; then
    
    # esplora dir corrente
	( cd "$filename" && esploraDirectoryCorrente )

   else
      ls -l "$filename"
   fi
done

}

# La funzione va invocata solo se la directory è accessibile
test -x . && esploraDirectoryCorrente
