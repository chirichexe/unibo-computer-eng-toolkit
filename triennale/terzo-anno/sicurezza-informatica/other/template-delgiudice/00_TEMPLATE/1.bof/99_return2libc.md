# return2libc

## Consegna

```
Esercizio simile a quello svolto in aula.

Il programma vulnerabile è returnlib

consegnare un file report.pdf che contenga:

- Payload e screenshot che dimostra la capacità di sovrascrivere l'indirizzo di ritorno
- Payload e screenshot dell'exploit finale lanciato
- Spiegazione dettagliata di come si è proceduto ad analizzare ed exploitare la vulnerabilità
```

## Soluzione

Con la vulnerabilità return2libc, sfruttiamo il fatto che probabilmente nel programma caricato (che usa delle funzioni libc di C) ci sia la `system`, che ci permette, per esempio, di eseguire una shell.

Dunque, come prima calcoliamo l'offest necessario per andare a sovrascrivere l'indirizzo di ritorno, usando il payload `$(perl -e 'print "\x90"xN,"BBBB"')`, attraverso prova ed errore. Scopriremo che questo valore sarà N=1512, dunque il payload sarà `$(perl -e 'print "\x90"x1512,"BBBB"')`.

A questo punto, dobbiamo trovare gli indirizzi delle parti che ci permettono di fare la return2libc. 
Questi sono:
1. la funzione `system`.
2. la funzione `exit`.
3. la variabile d'ambiente `SHELL`.

Le prime due possiamo trovarle facilmente in gdb con i comandi `p system` e `p exit`. Ci salviamo quindi gli indirizzi di questi, che sono nel nostro caso `0xf7e10000` e `0xf7e02950` rispettivamente. 

A questo punto, dobbiamo trovare la variabile SHELL. Per farlo, dobbiamo esamire la stack. Dunque, mettiamo un breakpoint sulla funzione main con `b *main` e poi andiamo a leggere lo stack con `x/500s $esp` (`s` fa visualizzare lo stack decodificando i byte in ASCII, così possiamo trovare facilmente SHELL).
La variabile SHELL sarà all'indirizzo `0xffffd531`. Tuttavia, la stringa completa a quell'indirizzo è "SHELL=/bin/bash", e a noi non interessano i primi 6 caratteri, Dunque, lo aumeteremo di 6 byte, ottenendo così `0xFFFFD537`

A questo punto il gioco è (quasi) fatto, quindi costruiamo il nostro payload:
```
$(perl -e 'print "\x90"x1512,"\x00\x00\xe1\xf7","\x50\x29\xe0\xf7","\x37\xd5\xff\xff"')
```

Abbiamo finito? NO. Infatti, gdb ci darà un errore dicendo che ci sarà un bit di valore NULL (interpretato come la fine di una stringa). Infatti, una delle stringhe del nostro payload inizia con `\x00`. Dunque che possiamo fare? Semplicemente, offesettiamo l'indirizzo finché l'operazione non va.

_WARNING_:Anche se ho fatto il procedimento in modo corretto, COMUNQUE tutto questo non va. Nemmeno il payload fatto dal prof va, danno tutti segmentation fault. Speriamo non metta questo esercizio...

**DISCLAIMER**: I nostri indirizzi possono cambiare di volta in volta... Quindi non è detto che quegli indirizzi funzinino. 
