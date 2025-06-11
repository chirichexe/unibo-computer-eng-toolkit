# AIDE

E uno strumento per verificare l'integrità dei dati sul filesystem. Nel file /etc/aide.conf vediamo:

- database_out è lo snapshot creato sul filesystem, da tenere come riferimento
- è il riferimento col quale viene confrontato il filesystem
- database_new può essere usato per confrontare due database tra loro (in vs. new invece che in vs. filesystem corrente)

    database_new può essere usato per confrontare due database tra loro (in vs. new invece che in vs. filesystem corrente)

la sezione GROUPS predispone nomi simbolici per set di controlli pre-aggregati

l'ultima riga @@x_include /etc/aide/aide.conf.d ^[a-zA-Z0-9_-]+$ istruisce AIDE a includere tutti i file di configurazione nella cartella menzionata

    (editando il file come root) la commentiamo per ridurre i tempi dei test e la sostituiamo con una nostra direttiva semplice per controllare tutti i file dentro /bin e /usr/bin
    /bin  f  Full
    /usr/bin  f  Full
## Avviamento
```sh
sudo aideinit

# per una "fotografia" più recente del fs:
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```
Primo test:

```
touch /bin/indesiderato

aide -C -c /etc/aide/aide.conf
```
