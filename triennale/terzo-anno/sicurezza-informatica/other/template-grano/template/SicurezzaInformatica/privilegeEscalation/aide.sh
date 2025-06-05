#Per accedere ai file aide sono necessari i privilegi di root
#1. 
sudo nano /etc/aide/aide.conf

#1.1 - Commentare l'ultima riga del file 
@@x_include /etc/aide/aide.conf.d ^[a-zA-Z0-9_-]+$

#1.2 - Aggiungere il fondo al file le seguenti righe:
-/etc f R
-/usr/bin f R

#2. 
sudo aideinit

#3. 
sudo cp /var/lib/aide/aide.db{.new,}


#---------------------ESECUZIONE---------------------
#Eseguo il malware dato
sudo ./change1

#Verifico le modifiche apportate
sudo aide -c /etc/aide/aide.conf -C
#Oppure specificare la directory da controllare per impiegare meno tempo
aide -c /etc/aide/aide.conf --limit /etc --check

#---------------------RISULTATO---------------------
f = p.. .c..... . : /usr/bin/cp
File: /usr/bin/cp
Perm      : -rwxr-xr-x   | -rwsr-xr-x

#In questo caso sono stati modificati i permessi del file /usr/bin/cp