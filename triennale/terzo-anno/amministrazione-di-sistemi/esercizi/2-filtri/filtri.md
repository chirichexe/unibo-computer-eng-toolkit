# cat

## A cosa serve
`cat` concatena e visualizza il contenuto di uno o più file su standard output

## Caso d’uso specifico
Concatenare due file di log in un unico file di audit:

```bash
cat access.log error.log > combined.log
```

Questo crea `combined.log` unendo i due file in sequenza

## Flag principali

- `-n, --number` – numerazione di tutte le righe in output 

- `-b, --number-nonblank` – numerazione solo delle righe non vuote

- `-s, --squeeze-blank` – comprime righe vuote consecutive in una sol
- `-E, --show-ends` – mostra `$` a fine riga

---

# less

## A cosa serve
`less` è un pager che permette di sfogliare file di testo (o output di comandi) pagina per pagina, con navigazione avanti/indietro

## Caso d’uso specifico
Esaminare un log di sistema molto grande senza caricarlo tutto in memoria:

```bash
less /var/log/syslog
```

Permette di cercare (`/pattern`), andare all’ultima riga (`G`), ecc.

## Flag principali

- `-N` – mostra numeri di riga 

- `-S` – tronca le righe troppo lunghe invece di andare a capo

- `-X` – non pulisce lo schermo alla chiusura

- `-F` – esce se il contenuto sta tutto in una schermata 

---

# rev

## A cosa serve
`rev` inverte l’ordine dei caratteri di ogni riga su standard output
[IBM - United States](https://www.ibm.com/docs/en)

## Caso d’uso specifico
Estrarre l’ultimo campo tab-delimitato di una riga usando `cut`, invertendo due volte:

```bash
rev file.txt | cut -f1 | rev
```

Utile quando `cut` non supporta direttamente “ultimo campo” 

## Flag principali

- `-0, --zero` – usa `\0` come separatore di riga

- `-h, --help` – mostra help ed esce

- `-V, --version` – stampa versione ed esce

---

# head

## A cosa serve
`head` stampa le prime N righe (default 10) di un file o di uno stream

## Caso d’uso specifico
Visualizzare rapidamente l’intestazione di un CSV per controllare i nomi delle colonne:

```bash
head -n 1 data.csv
```

Mostra solo la prima riga con i nomi dei campi

## Flag principali

- `-n, --lines=[-]NUM` – numero di righe da mostrare 

- `-c, --bytes=[-]NUM` – numero di byte da mostrare

- `-q, --quiet` – non mostra intestazioni di file multiple

---

# tail

## A cosa serve
`tail` stampa le ultime N righe (default 10) di un file o stream 

## Caso d’uso specifico
Monitorare in tempo reale un log di sistema:

```bash
tail -f /var/log/auth.log
```

Resta in attesa di nuove righe aggiunte al file 

## Flag principali

- `-n, --lines=NUM` – ultime NUM righe

- `-f, --follow[=name|descriptor]` – segue il file in tempo reale

- `-c, --bytes=NUM` – ultimi NUM byte

- `-q, --quiet` – non mostra intestazioni di file

---

# cut

## A cosa serve
`cut` estrae sezioni di ciascuna riga in base a byte, caratteri o campi delimitati

## Caso d’uso specifico
Estrarre il terzo campo di un file CSV (campo separato da `,`):

```bash
cut -d',' -f3 data.csv
```

Mostra solo la terza colonna

## Flag principali

- `-d DELIM, --delimiter=DELIM` – specifica il separatore di campo

- `-f LIST, --fields=LIST` – seleziona campi

- `-b LIST, --bytes=LIST` – seleziona byte

- `-c LIST, --characters=LIST` – seleziona caratteri

---

# sort

## A cosa serve
`sort` ordina le righe di uno o più file secondo vari criteri (alfabetico, numerico, campo)
[man7.org](https://man7.org/linux/man-pages/man1/sort.1.html)

## Caso d’uso specifico
Ordinare un elenco di utenti per UID (campo 3 in `/etc/passwd`):

```bash
sort -t: -k3n /etc/passwd
```

`-t:` imposta `:` come delimitatore e `-k3n` ordina numericamente sul terzo campo

## Flag principali

- `-n, --numeric-sort` – ordinamento numerico

- `-r, --reverse` – ordine inverso

- `-k FIELD[,FIELD], --key=...` – campo chiave

- `-t CHAR, --field-separator=CHAR` – separatore di campo
---

# uniq

## A cosa serve
`uniq` rimuove o segnala righe duplicate adiacenti in un input ordinato

## Caso d’uso specifico
Contare quante volte ciascuna parola appare in un testo:

```bash
sort words.txt | uniq -c
```

`sort` mette insieme duplicati, `uniq -c` ne conta le occorrenze

## Flag principali

- `-c, --count` – precede ogni riga col numero di occorrenze

- `-d, --repeated` – mostra solo le righe duplicate

- `-u, --unique` – mostra solo le righe uniche

- `-f N, --skip-fields=N` – ignora i primi N campi nella comparazione

---

# wc

## A cosa serve
`wc` conta linee, parole e byte/caratteri in file o stream

## Caso d’uso specifico
Sapere quanti file ci sono in una directory:

```bash
ls | wc -l
```

`ls` elenca i nomi, `wc -l` conta le righe, cioè i file

## Flag principali

- `-l` – conta solo le righe

- `-w` – conta solo le parole

- `-c` – conta i byte

- `-m` – conta i caratteri (distinto da byte)

---

# grep

## A cosa serve
`grep` cerca pattern (regex) nelle righe di file o stream, stampando quelle corrispondenti 
## Caso d’uso specifico
Estrarre tutte le righe di log che contengono “ERROR”:

```bash
grep -n "ERROR" /var/log/app.log
```

`-n` mostra il numero di riga per ciascuna corrispondenza


## Flag principali

- `-i, --ignore-case` – case-insensitive

- `-v, --invert-match` – mostra le righe che non corrispondono

- `-r, --recursive` – ricerca ricorsiva in directory

- `-n, --line-number` – mostra numero di riga

- `-E, --extended-regexp` – usa regex estese (`egrep`)

```sh
# Utilizzi comuni
grep -lq "pattern" file.txt # -q: quiet, -l: mostra solo il nome del file
```

# tee

## A cosa serve

Legge dallo standard input (stdin) e scrive sia su stdout che su uno o più file.

Utile per salvare l'output di un comando in un file senza perdere la visualizzazione a schermo.

```
ls -l | tee output.txt  # Mostra a schermo e salva in output.txt

echo "test" | sudo tee /root/protected_file.txt  # Scrive come root su file protetti
```
