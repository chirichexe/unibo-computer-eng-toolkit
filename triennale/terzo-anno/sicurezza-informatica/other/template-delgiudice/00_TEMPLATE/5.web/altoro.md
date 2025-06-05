# AltoroMutual

## Consegna

```
Lanciare la web app vulnerabile Altoro Mutual dallo script del pentestlab visto a lezione:

git clone https://github.com/eystsen/pentestlab.git
cd pentestlab
./pentestlab.sh start altoro
Puntare il browser a http://altoro

Questa macchina ha tante vulnerabilità. Trovarne ALMENO 3 e riportarle in un unico file report.txt con all'interno i dettagli, includendo.

Descrizione di come e perchè si è arrivati a scoprire la vulnerabilità
Payload utilizzato per sfruttarla
Conseguenze della vulnerabilità, cosa siete riusciti a fare di malevolo?
Quale secondo voi è il bug nel codice.
```

## Vulnerabilità trovate

1. Se si clicca sul sondaggio per vincere il telefono, dopo una lunga serie di input inutili, si viene a contatto con un input form. Se si insersce il payload `"> <script>alert("ciao")</script>` all'interno dell'input, verrà mostrato il messaggio subito dopo il reindirizzamento. In questo modo possiamo eseguire qualsiasi codice vogliamo nel sito, e possiamo vedere il contenuto di tag e variabili. Il metodo migliore consisterebbe nel sanificare l'input, impedendo stringhe con carattere `<` o `>`. Nel form del feedback/contact, abbiamo sempre una vulnerabilità del genere. Anche nella barra di ricerca. 

2. Nella schermata di login, possiamo eseguire un semplice SQL Injection mettendo le stringhe `a'OR''='` sia nel campo User che in quello password. In questo modo, la condizione della query sarà sempre vera, e dovrebbe ritornare i dati del primo utente della lista (che in questo caso è admin). In questo modo, possiamo entrare nell'account admin e fare mille porcherie. Un modo corretto per evitare questa vulnerabilità sarebbe sanificare l'input, in modo da impedire che ci siano apici.

3. bho, non so se le vulnerabilità tutte uguali dell'es 1 contino... Le altre che ho cercato online non funzionano qui.  