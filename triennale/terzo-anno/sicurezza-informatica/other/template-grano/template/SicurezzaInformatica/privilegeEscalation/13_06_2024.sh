Dopo aver scaricato il file in questione aggiorniamo l'immagine del db di aide prima di fare 
qualsiasi modifica

sudo aideinit

Eseguiamo lo script dato con sudo ./sudo ./change_2024_06_13 

Verifichiamo le modifiche apportate con il comando
sudo aide -c /etc/aide/aide.conf -C

Notiamo modifiche ai seguenti comandi 
- /etc/crontab
- /etc/passwd
- /etc/sudoers
- /usr/bin/vim.tiny
- /usr/bin/tee

Al comando crontab e stato rimosso il permesso di lettura per gli utenti di tipo other,
non sembra esserci alcun problema evidente di sicurezza

Il file /etc/passwd e stato modificato.
Tramite il comando diff /etc/passwd /etc/passwd- notiamo che e stato aggiunto un utente
intruso::1202:1000::/tmp:/bin/bash

Sono cambiate le ACL del file /etc/sudoers, l'utente intruso può ora leggere e modificarne il contenuto

Il comando vim.tiny riporta solo modifiche di tipo temporali, non sembrano essere rilevanti

Sono state modificate le capabilities del comando tee.
Verificando con getcap /usr/bin/tee si ottiene che non è stato modificato nulla di rilevante
/usr/bin/tee =


Il fatto che sia stato aggiunto un utente che può modificare il file sudoers, possiamo aggiungerci una regola affinche esso
possa utilizzare i poteri di root senza limiti.

su intruso
echo "intruso    ALL=(ALL:ALL) ALL" >> /etc/sudoers
sudo -i 
id