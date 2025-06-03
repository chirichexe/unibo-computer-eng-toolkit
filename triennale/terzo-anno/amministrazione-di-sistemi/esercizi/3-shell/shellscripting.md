
# Espansioni
## Quoting

- \ : il carattere successivo non sarà interpretato come speciale
- ' : tutto il testo tra i due apici verrà protetto dall'espansione
- " : come prima, a eccezione di ```$```, ``` ` ``` o ```\```

### Esempi

```bash
ls *\**   # lista i nomi dei file che contengono il carattere * in qualunque posizione
echo "$A" # stampa esattamente il contenuto della variabile A
echo '$A' # stampa esattamente $A
echo "'$A'" # chi vince?
echo $(ls) ; echo "$(ls)" # dov’è la differenza?
```

## Pathname expansion

- * : corrisponde a qualsiasi stringa di caratteri
- ? : corrisponde a un singolo carattere
- [ ] : un singolo carattere in un set ( negabile con !, può essere un intervallo ... )

### Esempi

```bash
echo *                # stampa i nomi di tutti i file nella directory corrente
echo [a-p,1-7]*[cfd]? # elenca i file i cui nomi hanno come iniziale un carattere compreso tra a e p o
                      # tra 1 e 7, se il penultimo carattere è c, f, oppure d.
echo \*               # esegue l'echo del carattere *, privato del suo significato di wildcard
echo *[!\*\?]*        # elenca tutti i file del direttorio corrente che abbiano almeno un carattere
                      # diverso dalle wildcard * e ?
echo /*/*/*           # elenca tutti i file dei direttori di secondo livello a partire dalla roo

```

## Brace expansion

È un meccanismo di espansione per generare sequenze di stringhesecondo un pattern con 
la stessa sintassi della pathname expansion, ma le stringhe sono generate **indipendentemente** 
dal fatto che **esistano o meno file** che rispettano il pattern

Sintassi: [PRE]{LISTA}[POST] oppure [PRE]{SEQUENZA}[POST] 
-> "a{b,c,d}e" diventa "abe ace ade". Posso scrivere anche l'incremento con "{10..40..5}", incrementa di 5 da 10 a 40

# Variabili

```bash
read A B
var1 var2 e ogni altra cosa andra in B

IFS:= A B
leggo variabili:separato da duepunti 
```

## Settate da Bash:
- `BASHPID`: PID della shell corrente.
- `$`: PID della shell "capostipite".
- `PPID`: PID del parent process della shell "capostipite".
- `HOSTNAME`: Nome dell'host.
- `RANDOM`: Un numero casuale tra 0 e 32767.
- `UID`: ID utente che esegue la shell.

## Usate da Bash:
- `HOME`: Home directory dell'utente.
- `LC_*`: Variabili per la scelta dei vari aspetti della localizzazione (vedi `man locale(7)`, `locale(1)`, `locale(5)`).
- `PS0`..`PS4`: Prompt in diversi contesti.

## Argomenti degli script

Ogni script può accedere agli argomenti indicati sulla propria linea di comando utilizzando variabili numeriche:

- `$0`, `$1`, `$2`, ...: rappresentano rispettivamente il comando, il primo argomento, il secondo argomento, e così via.
    - Per argomenti con indice maggiore di 9, è obbligatorio utilizzare la sintassi `${NUM}`.

- `$*` e `$@`: espandono in `$1 $2 ...`, ma possono causare problemi con argomenti contenenti caratteri speciali.

# Array

# Cicli
## for
for NAME [in WORDS ... ] ; do COMMANDS; done


# Ridirezioni
```bash
echo ok > file # sovrascrive, >>: append .
echo ls 2> file # ridirige standard error
grep "mondo" <<< "ciao mondo" # passa una stringa come input a un comando.
```

## Esempi
```bash
ls > miofile 2>&1 # ridirige lo stderr dentro stdout e poi stdout su file
sort < miofile # ridirige il contenuto di miofile dentro stdin di sort 
```

# Test
```bash
if [ "$a" -eq 5 ]; then
  echo "a è 5"
fi  

## doppia [[]] è più potente
if [[ "$nome" == A* ]]; then
  echo "Inizia con A"
fi

if [[ "$str" =~ ^[0-9]+$ ]]; then
  echo "È un numero"
fi

```

# Evaluation

## Esempi
```bash
((a = 5 + 3))
((a > 6)) && echo "Maggiore di 6"

if ((a == 8)); then
  echo "a è 8"
fi

```

# Subshell 
N.B.: Una pipeline che contiene un builtin crea una subshell implicita
un comando builtin è un comando che non è un programma esterno, ma è implementato direttamente nella shell

Utilizzo: 
> producer | ( step1 ; step2 ; step3 ) 2>/dev/null | consumer

## Esempi
```bash
echo ciao | read A
echo $A # non stampa niente

echo ciao | ( read A ; echo $A ) # le variabili non persistono fuori dalla subshell
```

# Interazioni con i processi

```bash
#handler
trap [-lp] [[codice_da_eseguire] segnale …]

#invio
kill [options] <pid> […] # CTRL + ( C=INT | Z=STOP | \=QUIT )

sleep N # sleep per N secondi del processo 

[comando] & # esegue il comando in background

wait [pid] # attende la terminazione dei processi in background

bg %job_id # riprende un processo in background

fg %job_id # riprende un processo in foreground

nohup [comando] # esegue il comando in background e lo rende immune a SIGHUP.
                # redirige stdout e stderr in nohup.out


```