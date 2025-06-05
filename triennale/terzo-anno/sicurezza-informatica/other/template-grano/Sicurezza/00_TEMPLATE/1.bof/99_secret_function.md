# Funzione Segreta

## Consegna

```
Esercizio simile a quello svolto in aula.

Il programma vulnerabile è secret_function

consegnare un file report.pdf che contenga:

Payload e screenshot che dimostra la capacità di sovrascrivere l'indirizzo di ritorno
Payload e screenshot dell'exploit finale lanciato
Spiegazione dettagliata di come si è proceduto ad analizzare ed exploitare la vulnerabilità
```

## Soluzione

Essenzialmente, facciamo come sempre, prima di tutto apriamo gdb e runniamo il programma con una stringa a caso, e vedremo che il programma da in output la stringa. 
Poi, iniziamo il processo di prova ed errore. 

Prima di tutto, troviamo il numero di byte necessario a sovrascrivvere l'indirizzo di ritorno. Per farlo, usiamo il comando `run $(perl -e "A"xN)`, dove cambiamo N in un numero tale finché gdb non ci darà 0xAAAA (ovvero 0x41414141) come indirizzo di ritorno che ha causato il segfault. 
Facendo più esperimenti, otteniamo che il numero necessario di byte è 20, dunque avremo bisgno di 16 byte di "filler". A questo punto, possiamo esplorare le funzioni contenute nel nostro programma usando il comando `info functions`, e potremo vedere tutte le funzioni nel binario. 

Dunque, abbiamo 5 funzioni "sospette", che da loro nome e dalla loro posizione in memoria (sono tutte adiacenti) possiamo intuire ci portino al risultato che cerchiamo. 

Scriviamo quindi l'indirizzo di ciascuna delle funzioni in little endian (ovvero con i byte invertiti) all'interno del nostro payload. 

Finalente, troviamo la funzioen che ci ritorna il flag `SEC{simple_buffer_overflow_with_secret_7unction}`, che era la funzione `secret_function_not`, e il payload finale sarà quindi `$(perl -e 'print "A"x16,"\xb4\x66\x55\x56"')`,
 