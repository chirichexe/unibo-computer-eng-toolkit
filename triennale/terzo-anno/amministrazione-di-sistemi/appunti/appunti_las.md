# LEZIONE 1: Creazione macchina virtuale con Vagrant 

1. Avvia il file setup_new.sh spostato nella directory ~/.local
>https://virtuale.unibo.it/pluginfile.php/2465551/mod_resource/intro/setup_new.sh?time=1740480091299
2. Crea nella directory local una directory test
3. Esegui all'interno della dorectory test
```sh
vagrant init debian/bookworm64 # Crea il file vagrant
vagrant up # Crea una chiave privata sull'host e installa la pubblica sulla Vm
vagrant ssh # Entro come sudo senza password
```

## Creazione VM tramite virtualbox
Machine > Create VM > Scegli l'ISO > Scegli i parametri di hardware > 
Possibilità di non aggiungere disco (utile in caso di test)
> Tips:
> - Imposta la video memory (tra le impostazioni) al massimo

# LEXIONE 2: Introduzione alla shell da riga di comando
- ```id, whoami, who``` per vedere chi siamo, in particolare: identità e gruppo di appartenenza, il proprio username, chi è collegato alla macchina
- ```pwd``` per vedere la directory corrente

## Tipologie di comandi** 
distinguibili con ```type [comando]```

- **keyword**: comandi che non sono eseguiti come processi separati, ma come parte del codice della shell. MODIFICANO esecuzione di altri comandi 
- **```builtin```**: comandi interni alla shell, eseguiti direttamente dal codice interno che lo converte in azioni su SO
- **Esterni ```command```**: file eseguibili localizzati nel file system, eseguiti come processi separati
- **```alias``` e ```unalias```**: comando che esegue un altro comando, può essere definito dall'utente
- **Funzioni**: come alias, ma con parametri

# LEZIONE 3: Esercizi shell riga di comando
## Parte 1: Esempi

```ls -lR / | grep [string]``` grep lavora su ogni riga prodotta dal primo comando

- ```tr``` traduttore, può ad esempio mappare 

- ```uniq -c``` elimina duplicati consecutivi, indica anche il numero di righe compattate in una
- ```uniq -d``` mostra solo le entry non singole

- ```sort``` ordina in modo lessicale. L'ordine dei caratteri:
    - se LC_ALL=C → valore dei byte che li codificano
    - diversamente → ordine stabilito dal locale scelto
opzioni che controllano il comportamento globale
    -u elimina le entry multiple (equivale a sort | uniq)
    -r reverse (ordinamento decrescente)
    -R random (permutazione casuale delle righe)
    -m merge di file già ordinato
    -c controlla se il file è già ordinato
    -b ignora gli spazi a inizio riga
    -d considera solo i caratteri alfanumerici e gli spazi
    -f ignora la differenza minuscole / maiuscole
    -n interpreta le stringhe di numeri per il valore numerico
    -h interpreta i numeri “leggibili” come 2K, 1G, ecc.    
> Esempio:
```sh
 ls -lRs /     # lista in modo ricorsivo tutto il sottoalbero
| head -1000  # prende le prime 1000 righe
| sort        # le ordina 
```
> Esercizio: ordinare a parità di shell 

> Esercizio: generare casualmente un numero ($RANDOM) da 1 a 40
```sh
echo $((RANDOM % 40)) # Valuta l'espressione modulo 40
```

- ```dev/urandom```: pesca dall'entropy pool una sequenza *pseudo casuale*, una riserva di byte casuali di alta qualità 
dà uno stream fino a fine lettura
- ```dev/random```: possibilità di esaurire l'entropy pool-

> Esercizio: primi 10 caratteri random
```head -1 /dev/urandom``` 

> password che contiene solo caratteri stampabili, lunga almeno 20 caratteri, che non abbia caratteri ripetuti
```sh 
head -1 /dev/urandom  
| tr -d -c '[:graph]' 
| egrep '[a-z]{2,2}' # Chiedi cosa faccia
```

> Esercizio: cercare un utente specifico
```sh
grep -w root /etc/passwd # il flag -w cerca una parola specifica
``` 

> ! Esercizio: stampare tutti gli ip di ip a che assomigliano a un "ip"
```sh
ip a | egrep -o '([0-9]{1,3}\.){3,3}[0-9]{1,3}/' 
```

> Utilizzo di *
sed*: aggiungere in coda a i testi una stringa
```sh
sed -e 's/^/Dr. /'
```

> Esercizio: Stampa la home dir per tutti gli utenti
```sh
cut -f6 -d: /etc/passwd
ls -lR $(cut -f6 -d: /etc/passwd) # entra ricors. in tutte le directory
```

### Xargs e less

 -xargs analizza lo stream di dati riga per riga e, come ulteriore parametro, ci mette l'argomento "nuovo". In pratica le riceve via pipeline una dietro l'altra e una dopo l'altra esegue un'operazione specificata. Più efficiente.
 ```ls -lR $(cut -f6 -d: /etc/passwd) | xargs ls -l```

- less command substitution prende l'intero output del comando e lo mette al posto del $
 ```ls -lR $(cut -f6 -d: /etc/passwd) | less```

## Parte 2
- Avvio macchina con ```vagrant up``` sulla directory con il Vagrantfile e mi collego con ```vagrant ssh```.
- Creo file con ```touch 'a' 'a*' 'a2' 'b1' 'b11' ``` (apici singoli importanti per essere certi!)
- Imposto una variabile ad es. `A=a*`, contiene un carattere speciale (pathname expansion), se voglio stamparla posso fare ```echo "$A"``` con gli apici doppi, i quali non inibiscono l'espansione delle variabili
> reminder: Apici singoli inibiscono tutto, i doppi non il dollaro

*Esempio notevole:* echo $A con A={a1,a2}, stampa ancora a1,a2 senza brace expansion, in quanto avviene prima
Soluzione: utilizzo di "eval", che fa un'ulteriore espansione del codice (non esecuzione)

*Array*

- ``` set "buon" "giorno" ``` e ```echo $1 $2```, stampa buon e giorno
- Shell è interpretato, possiamp tranquillamente fare una cosa così ```MYV[11]="ciao mondo"``` e ```MYV[0]="ciao mondo 2"```, non abbiamo il vincolo di riempire le altre celle. 
- Li stampo con ```echo ${MYV[@]}```. Con ```echo ${!MYV[@]}``` ho gli indici che ho riempito.

*Array associativi*

```sh
vagrant@bookworm:~/11marzo$ read VAR
my-var
vagrant@bookworm:~/11marzo$ echo $VAR
my-var
```
Utilizzo di subshell
```echo ciao | ( read $PROVA ; echo $PROVA )``` Non dà nulla

```echo ciao | (read $PROVA ; read TASTIERA < /dev/pts/0 ; echo $PROVA $TASTIERA) ```
1. produce stdoptput
2. viene redirezionato a una subshell che inizia leggendo da standard input
3. la redirezione dice che lo standard input della read deve essere preso dalla tastiera (ottenuta con comadno tty)

# LEZIONE 4: Shell scripting
## Prima parte: CLI

## Seconda parte: shell coding
- Utilizzo della funzione "test" per controllare se c'è un parametro

```sh
#!/bin/bash

[[ -z "$1" ]] && { echo manca parametro; exit 1; }  # Il primo è equiv. a "test". se restituisce false, esegue l'and, la seconda condizione
echo proseguo
```

- Creazione di funzione per stampare errori
```sh
#!/bin/bash

function printerror() {
    # $1: parametro per exit code
    # $2: parametri successivi stringa da stampare
    echo $2
    exit $1
}

[[ -z "$1" ]] && printerror 1 "manca parametro"

echo proseguo
```

- Creazione funzioni con parametri shiftati

```sh
#!/bin/bash

function printerror() {
    # $1: parametro per exit code
    # $2: parametro stringa spe iale
    # $3, 4... parametri successivi stringa da stampare
    
    CODE=$1
    SPECIAL=$2
    shift 2
    
    echo "Parametro speciale: " $SPECIAL
    echo $@
    exit $CODE
}

[[ -z "$1" ]] && printerror 1 RIPROVA "manca parametro"

echo proseguo
```

--- 
_tutto fino a slide 37_
---

### If, swith e cicli
```sh

# Condizioni con switch
if COMANDO1
then
 comandi eseguiti se COMANDO1 ritorna true
[ elif COMANDO2
then
 comandi eseguiti se COMANDO2 ritorna true ]
[ else
 comandi eseguiti se nessun ritorno true ]
fi

# Switch
case "$variabile" in
nome1) echo vale nome1 ;;
nome?) echo vale nome2, nomea, nomez ;;
nome*) echo vale nome11, nome, nomepippo ;;
[1-9]nome) echo vale 1nome, 2nome, …, 9nome ;;
*) echo non cade in nessuna delle precedenti ;;
esac

# Ciclo for
for NAME [in WORDS ... ] ; do COMMANDS; done
# for i in * ; do echo $i ; done
``` 
--- 
_Vedi foto + fai estensione + fino a slide 50 (leggi solo)_
---

# Terza parte: Misure del tempo
```sh
# Stampo la data attuale
EXT=$(date +%Y%m%d)
echo $EXT
```

Dati in quantità imprevedibile: utilizzo di file system, altrimeti sfrutta la RAM 
Utilizza quindi la pipeline nel primo caso

- Creazione **file temporaneo**: ```mktemp``` : formato /tmp/tmp.XXXXXXXXXX
_Esempio_

```cat /etc/passwd | while IFS=: read NOME X IDENT RESTO; do echo $NOME $IDENT; done | head -3``` piuttosto che ```for RIGA in $(cat FILE)...```

Il piping sfrutta il SO, non so la dimensione di etc/passwd. 

Possoo anche fare parsing della riga senza usare cut etc..., inoltre ho già le variabili adeguate memorizzate.

---
_Vedi esercizi risolti_
---

## Quarta parte: Processi in background
### Esercizio: lancio tre processi in background, ogni 5 secondi mi mostra quelli ancora vivi. Termina quando sono terminati tutti

```sh
sleep 100 &        # Lancio in background, la variabile viene memorizzata in $!
                   # posso memorizzarla con ad esempio PID=$! 
```

```sh
while ps $PRIMO $SECONDO $TERZO ; do sleep 5; done
```
# Tips:
- Nelle variabili usa sempre apici doppi "$VAR"

# Approfondisci

- 2>, <<<, >>> 
- IFS