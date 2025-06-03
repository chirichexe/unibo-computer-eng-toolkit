# Comandi generali

```sh
# assunzione identità
su -p [nomeutente]
su -c [comando] [nomeutente]

# aggiungere utenti, impostare password e aggiungere gruppi
useradd -m -s /bin/bash maria
useradd -m -s /bin/bash piero
passwd maria
passwd piero
groupadd programmatori
usermod -a -G programmatori maria
usermod -a -G programmatori piero

# creazione directory di collaborazione
mkdir /home/programmatori
chgrp programmatori /home/programmatori

# assegnazione permessi
chmod g+ws /home/programmatori

# prenotazione spazio
dd if=/dev/zero of=file.out bs=4k count=16k # trasferisce 16k blocchi di dimensione 4k da /dev/zero a file.out
```

