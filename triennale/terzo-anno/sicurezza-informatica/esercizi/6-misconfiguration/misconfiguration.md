# Misconfiguration

Strumenti per rivelare modifiche fatte a un sistema

**Obiettivo**: un utente non privilegiato (user_test) sfrutta una configurazione insicure per ottenere accesso root.

**Strategia**:

# 1. SUDOERS (modificabile tramite comando visudo)
Se ho un utente @user_test, aggiungo su visudo questa riga: ```user_test ALL=(root) NOPASSWD:/usr/bin/vi /var/www/html/*```, per dargli accesso sudo
senza password per eseguire solo vi sul file in /var/www/html/*

Per vedere cosa un utente privilegiato non può fare: ```sudo -l -U user_test```

```sh
# MODALITÀ 1:

sudo /usr/bin/vi /var/www/html/file_a_caso # ho accesso qui
# se dentro vi digito: :!/bin/bash 
# verrà avviata una shell root senza password
# perchè vi è stato eseguito come root con sudo

# MODALITÀ 2:
# path trasversal

sudo /usr/bin/vi /var/www/html/../../../etc/shadow

# MMODALITÀ 3:

```
# 2. SUID

**UTILE**: Ricerca di file o directory con permessi speciali settati: ```find / -perm /7000```

Voglio usare cp per copiare file di sistema protetti (come /etc/passwd e /etc/shadow) e modificarli indirettamente

Il bit suid asegnato viene eseguito con i permessi del proprietario (in questo caso root), anche se avviato da un utente normale.

Da root assegniamo il SUID bit al comando cp 

```sh
sudo chmod u+s /bin/cp #attivo suid
ls -al /bin/cp
-rwsr-xr-x 1 root root 146880 Feb 28 2019 /bin/cp

# copio i file
cp /etc/passwd .
cp /etc/shadow .
ls -l

-rw-r--r-- 1 root vagrant 1503 Jun  1 17:38 passwd
-rw-r----- 1 root vagrant  864 Jun  1 17:39 shadow
```
cp è eseguito come root (grazie al SUID), quindi i file copiati mantengono lo stesso proprietario (root).

Problema: Non puoi modificarli direttamente perché appartengono a root

Ne creiamo quindi una copia leggibile, li modifichiamo, e li ricopiamo al posto di quelli oroginali

```sh
cat passwd > pass.rw    # Crea una copia leggibile/scrivibile
cat shadow > shad.rw    # Stessa cosa per shadow
ls -l
```

# 3. ACL

Le ACL POSIX sono un'estensione dei permessi standard, che permette di assegnarli specificamente a soggetti diversi da proprietario, gruppo proprietario, e "altri".

Gli strumenti per manipolarle fanno parte del pacchetto acl

Ad esempio ```setfacl -m u:kali:rw /etc/sudoers```

renderebbe manipolabile il file sudoers dall'utente kali anche se questo non avesse alcun modo di guadagnare i privilegi di root

La ricerca di file con ACL non standard impostate si può condurre con: ```getfacl -sR /```

# 4. CAPABILITIES

Sono gli specifici permessi di svolgere operazioni privilegiate, caratteristiche di root. Diventando root si acquisiscono tutte le capabilities esistenti, come visto i programmi SUID usano questo meccanismo per concedere azioni privilegiate a utenti standard.

```sh
sudo /usr/sbin/setcap "CAP_DAC_OVERRIDE=eip" /usr/bin/vim.tiny
```
Assegna a vim.tiny la capacità (CAP_DAC_OVERRIDE) di ignorare i permessi di lettura/scrittura sui file, anche quelli di sistema protetti.

# 5. AIDE

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
