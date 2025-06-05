# WriteVar

## Consegna

```
Esercizio simile a quello svolto in aula.

Il programma vulnerabile è write_var

consegnare un file report.pdf che contenga:

Payload e screenshot che dimostra la capacità di sovrascrivere la variabile
Payload e screenshot dell'exploit finale lanciato
Spiegazione dettagliata di come si è proceduto ad analizzare ed exploitare la vulnerabilità
```

## Soluzione

Essenzialmente, facciamo come sempre, prima di tutto apriamo gdb e runniamo il programma con una stringa a caso, e vedremo che il programma da in output la stringa. 
Poi, iniziamo il processo di prova ed errore. 

Per trovare il payload che ci tornerà la flag, facciamo uso del compilatore JIT di perl per scrivere un numero di byte pari alla quantità necessaria per raggiungere l'indirizzo richiesto dall'applicazione. 

In particolare, usiamo in gdb il comando perl -e "A"xN, "\x56\x76" etc...
Dopo aver trovato il numero di byte necessario a fare in modo che l'indirizzo della variabile sia effettivamente cambiato, scriviamo l'indirizzo richiesto in senso contrario (causa little endianess). 

Se tutto va bene, l'applicazione ci ritornerà la flag giusta, che in questo caso è `SEC{thisistherightflagidiot!}`.

Il payload usato finale usato è `run $(perl -e "A"x1324, "\x45\x44\x43\x42")`.