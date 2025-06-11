#!/bin/bash
# ciclo principale - iterazione sulla cartella corrente

function esploraDirectoryCorrente() {

for filename in *       # bash cura l'espansione corretta dei nomi
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
