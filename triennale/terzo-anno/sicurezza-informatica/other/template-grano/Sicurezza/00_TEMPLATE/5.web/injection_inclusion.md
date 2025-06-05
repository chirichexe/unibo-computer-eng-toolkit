# Injection and Inclusion

## Consegna

### SQLi
La challenge consiste nello sfruttare una sql injection per bypassare il login

Il login si effettua attraverso una chiamata GET al indirizzo /login con parametri username e password e.g. /login?username=&password=

Scopo dell'esercitazione e' loggarsi come utente admin

Per risultare corretto l'esercizio lo studente deve consegnare: la FLAG, la query completa che sfrutta l'SQLi, una breve descrizione sui passaggi eseguiti, il perche' la vulnerabilita' esiste e come viene sfruttata.

Consegnare soltanto la Flag non sara' ritenuto sufficente.

### LFI

La challenge consiste nello sfruttare una LFI (Local File Inclusion)
Attraverso una richiesta GET alla root / con il parametro path, e' possibile aprire un file locale. e.g. /?path=file_locale.txt
Scopo dell'esercitazione e' quello di sfruttare la LFI e recuperare/leggere il file /etc/passwd
Sono presenti alcuni filtri sui caratteri che e' possibile inviare come percorso
Per ogni filtro "matched" verra' proposto un piccolo suggerimento
Lo studente dovra' quindi consegnare 3 file

1) Il file report.txt dove dovra' spiegare in maniera comprensibile il concetto dietro alla vulnerabilita' di questa challenge.

Lo studente dovra' inoltre elencare i vari passaggi e tentativi eseguiti per sfruttare la vulnerabilita', con i ragionamenti effettuati per "bypassare" i filtri, incluso ovviamente il payload finale

2) Lo screenshot dove e' possibile vedere chiaramente la chiamata all'applicazione con il payload e il risultato finale.
3) Il file etc/passwd

La qualita' del report incidera' sulla valutazione della parte pratica.

### Command Injection

La challenge consiste nello sfruttare una command injection
Attraverso una richiesta GET alla root / con il parametro domain, e' possibile fare la richiesta dns ad un sito. e.g. /?domain=www.ulisse.unibo.it
Scopo dell'esercitazione e' quello di sfruttare la command injection e recuperare/leggere il file /etc/passwd
Sono presenti alcuni filtri sui caratteri che e' possibile utilizzare
Per ogni filtro "matched" verra' proposto un piccolo suggerimento
Lo studente dovra' quindi consegnare 3 file

1) Il file report.txt dove dovra' spiegare in maniera comprensibile il concetto dietro alla vulnerabilita' di questa challenge.

Lo studente dovra' inoltre elencare i vari passaggi e tentativi eseguiti per sfruttare la vulnerabilita', con i ragionamenti effettuati per "bypassare" i filtri, incluso ovviamente il payload finale

2) Lo screenshot dove e' possibile vedere chiaramente la chiamata all'applicazione con il payload e il risultato finale.
3) Il file etc/passwd

La qualita' del report incidera' sulla valutazione della parte pratica.

## Soluzione 

### SQLi
Il flag è `SEC{Today_a_young_man_on_acid_realized_that_all_matter_is_merely_energy_condensed_to_a_slow_vibration_that_we_are_all_one_consciousness_experiencing_itself_subjectively,_there_is_no_such_thing_as_death,_life_is_only_a_dream,_and_we_are_the_imagination_of_ourselves._Here's_Tom_with_the_weather.}`.

Lo otteniamo attraverso il payload: http://10.10.10.10:8001/login?username=a%27%20OR%20%271%27=%271&password=a%27%20OR%20%271%27=%271, in cui essenzialmente mettiamo sia per l'username che per la password la stringa `a' OR ''='`. In questo modo, la query sarà sempre vera. 

La cosa brutta di questa mini CTF è il fatto che c'è un redirect, dunque usiamo Burp per intercettare la richiesta e la risposta. Per risolvere, possiamo sanificare l'input in modo che non ci siano spazi in questo caso, siccome la stringa senza spazi viene considerata come un errore per SQLite. 
La VM fornita, inoltre, è fucking broken al 100% proprio. 

### LFI

L'LFI è una vulnerabilità che consiste nel fare in modo che la webapp riveli dei file nel filesystem del web server in cui questa gira.

Il payload usato è stato `http://10.10.10.10:8002/?path=/./etc/passwd*`. I passi per la risoluzione sono stati questi:
1. Ho tentato di fare path traversal, `?path=../../../etc/passwd`. Questo ha causato prima un messaggio in cui si consigliava implicitamente di non usare path traversal, e poi da dei messaggi d'errore.
2. Ho tentato quindi il semplice payload `?path=/etc/passwd`, non ha funzionato e sono stato accolto da una schermata che mi diceva che l'accesso diretto non era effettivamente possibile :rage: . 
3. Ho tentato quindi ad accedere il file in modo indiretto, usando `?path=/./etc/passwd`, tuttavia l'url non poteva terminare con wd, e c'era un "hint" all'uso delle wildcard. 
4. Allora ho usato il payload `?path=/./etc/passwd*`, che ha funzionato :smile: .


Il file /etc/passwd è incluso nella cartella di questo markdown. 

### Command Injection

Con Command Injection si intende una vulnerabilità di un sito attraverso la quale si quale si possono eseguire dei comandi bash sul server della webapp. 

Il payload è `http://10.10.10.10:8003/?domain=|%20tail%20/etc/passw?`, che è stato ottenuto in questi passi:

1. Ho tentato l'opzione più semplice, e semplicemente ho usato il payload `?domain=|cat /etc/passwd`. Il server però ha sanificato l'input, bloccando il comando `cat`. 
2. Dunque, ho riscritto il payload usando il comadno `tail`, ottenendo così `?domain=|tail /etc/passwd`. A questo punto, il server ha risposto dicendo che il suffisso della stringa non poteva essere "wd", dando l'hint dell'uso di una wildcard. 
3. Allora, ho usato `?domain=|tail /etc/passwd*`. Tuttavia, sono comparsi i risultati di due file, e noi ce ne serve solo uno. Quindi...
4. ... ho riscritto il payload in `?domain=|tail /etc/passw?`, per impedire che la stringa avesse dei caratteri extra. Questo ha funzionato. 

Anche per questo, il ""flag"", ovvero il file /etc/passwd, è incluso in questa cartella.