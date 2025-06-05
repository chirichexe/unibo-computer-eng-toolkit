#----------------------CRAK DI UN ARCHIVIO .rar----------------------
#Vogliamo cercare la password per l'archivio crack_esercitazione.rar
Scarico la wordlist dal sito assegnato
cewl https://ulis.se/ > ~/Desktop/wordlist   

Attraverso il comando rar2john ottengo l'hash del file  
rar2john ./Downloads/crack_esercitazione.rar > ./Desktop/passwordRar


Nella cartella Desktop lancio il seguente comando
john --wordlist=./wordlist passwordRar
il risultato ottenuto è la password
cyberchallenge   (crack_esercitazione.rar) 

tramite il comando unrar posso scompattare l'archivio
unrar x -p cyberchallenge ./Downloads/crack_esercitazione.rar

Provo a scompattare la cartella con la password assegnata, lo scompattamento
da come risultato una cartella vuota.

#----------------------CRAK DI UN ARCHIVIO .rar----------------------
#Analogamente possiamo fare lo stesso con un file zip
#Scarico il file zip
wget https://ulis.se/crack_esercitazione.zip
#Ottengo l'hash del file
zip2john ./Downloads/crack_esercitazione.zip > ./Desktop/passwordZip
#Lancio il comando john
john --wordlist=./wordlist passwordZip
#La password ottenuta è
cyberchallenge   (crack_esercitazione.zip)
unzip -P cyberchallenge crack_esercitazione.zip


#----------------------CRAK DI UN HASH----------------------
#L'hash è il seguente : 85064efb60a9601805dcea56ec5402f7
Utilizziamo il tool di kali hash-identifier per identificare il tipo di hash
hash-identifier
#Il tipo di hash è MD5
#Utilizziamo il tool john per crakare l'hash

echo "hashdacraccare" > ./Desktop/hash

#Diciamo a john che l'hash è di tipo md5
john --format=raw-md5 --wordlist=./wordlist ./Desktop/hash


#-----------------------------------------------------------------------------
#Creazione di una wordlist 
cewl -d 1 -m 5  https://www.unibo.it/sitoweb/marco.prandini/publications  > prandaWl

# argomenti :
# -d : dimension
# -m : lunghezza minima parole
# -x : lunghezza massima


#Creazione di una wordlist interattiva
cupp -i


#----------------------CRAK DI PASSWORD DEL FILE PASSWD E SHADOW----------------------
#Per crakare le password del file passwd e shadow è possibile utilizzare il comando unshadow
unshadow /etc/passwd /etc/shadow > ./Desktop/passwdShadow
#Creo una wordlist
cewl -d 1 -m 5  https://www.unibo.it/sitoweb/marco.prandini/publications  > prandaWl
#Effettuo il crak
john --wordlist=./prandaWl ./Desktop/passwdShadow

