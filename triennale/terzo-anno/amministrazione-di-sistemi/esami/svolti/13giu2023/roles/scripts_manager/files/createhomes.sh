#!/bin/bash

LOGFILE=/var/log/homes.log

# Lo script /bin/createhomes.sh deve essere collocato sul Manager e osserva senza interruazione 
# il file /var/log/homes.log. Per ogni nuova riga:

tail -f $LOGFILE | while IFS='_' read -r _ TYPE USER IP _ ; do 
    # ricava dal messaggio il "tipo" (NEW o EXIT), l'indirizzo IP e l'utente USERNAME

    if [[ $TYPE == "NEW" ]] ; then
        # se il tipo è NEW

        # si collega via ssh come root all' IP e crea la home directory di USERNAME sistemando le ownership e 
        # concedendo permessi completi solo a USERNAME stesso.
        # crea nella home un file .bash_logout contenente il comando /bin/backup.sh
        # se sul Manager esiste il file /backups/USERNAME.tgz, ne estrae il contenuto nella home di USERNAME sulla workstation IP

        ssh "root@$IP" " mkdir /home/$USER ; chown -R $USER:$USER /home/$USER ; chmod -R 700 /home/$USER ; echo '/bin/backup.sh' > /home/$USER/.bash_logout " 
        
        if [[ -f "/backups/$USER.tgz" ]] ; then 
            ssh root@$IP "tar -xz -C /home/$USER" < /backups/$USER.tgz
        fi

    elif [[ $TYPE == "EXIT" ]] ; then
        # se il tipo è EXIT

        # crea (o sostituisce) sul Manager il file /backups/USERNAME.tgz inserendovi il contenuto della home di 
        # USERNAME sulla workstation IP

        ssh root@$IP " tar -cz -C /home/$USER . " > /backups/$USER.tgz 

    else
        echo "type unrecognized..."
    fi

done