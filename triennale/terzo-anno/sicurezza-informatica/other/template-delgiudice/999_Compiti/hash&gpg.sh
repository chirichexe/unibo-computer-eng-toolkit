#! /bin/bash

#------------------------------------------------------------------------------------------------------------
# 1) Salvare in un file di nome esgpg.txt l'output del comando uname -a della vm del corso
uname -a > esgpg.txt


#------------------------------------------------------------------------------------------------------------
# 2) Salvare in un file di nome esgpg.sha l'hash del file esgpg.txt calcolato con l'algoritmo sha512 (man sha512sum)
sha512sum esgpg.txt | cut -d' ' -f1 > esgpg.sha


#------------------------------------------------------------------------------------------------------------
# 3) Cercare sul sito web http://pgp.mit.edu le chiavi pubbliche di Marco Prandini e Andrea Melis
# -> mp_key.pub
# -> am_key.pub


#------------------------------------------------------------------------------------------------------------
# 4) Importare in gpg da pgp.mit.edu le chiavi pubbliche dei suddetti destinatari
gpg --import mp_key.pub
gpg --import am_key.pub


#------------------------------------------------------------------------------------------------------------
# 5) Generare una coppia di chiavi RSA con GPG associate al vostro indirizzo @studio.unibo.it
gpg --gen-key


#------------------------------------------------------------------------------------------------------------
# 6) Caricare l'identificativo della chiave qui come consegna dell'esercizio
#  C233001CE1412AEF8D3D9845FC9DE5C33501A4F7


#------------------------------------------------------------------------------------------------------------
# 7) Caricare la chiave pubblica sul server pgp.mit.edu
gpg --keyserver pgp.mit.edu --send-keys C233001CE1412AEF8D3D9845FC9DE5C33501A4F7 
gpg: sending key FC9DE5C33501A4F7 to hkp://pgp.mit.edu


#------------------------------------------------------------------------------------------------------------
# 8) Cifrare per i suddetti destinatari il file esgpg.sha
gpg --encrypt --armor -r marco.prandini@unibo.it -r andrea.melis@unibo.it esgpg.sha



#------------------------------------------------------------------------------------------------------------
# 9) Firmarlo
#Sufficente aggiungere opzione --sign al comando precedente)
gpg --encrypt --armor --sign -r marco.prandini@unibo.it -r andrea.melis@unibo.it esgpg.sha

#output -> esgpg.sha.asc


#------------------------------------------------------------------------------------------------------------
# 10) Spedirlo via mail ai suddetti destinatari
#      L'oggetto della mail deve essere "Esercitazione SEC GPG 2023 " -
