#!/bin/bash
# Script di esempio per gestione utenti, gruppi e permessi
# Autore: Davide Chirichella
# Matricola: 0001071414

# 1. Aggiungere un nuovo utente
USERNAME="esempio_user"
sudo useradd -m $USERNAME
echo "Utente $USERNAME creato."

# 2. Impersonare l'utente (cambiare utente nella sessione)
# NOTA: questo non funziona direttamente nello script, va fatto manualmente!
echo "Per impersonare l'utente eseguire: sudo su - $USERNAME"

# 3. Creare un nuovo gruppo e assegnare l'utente
GROUPNAME="esempio_group"
sudo groupadd $GROUPNAME
sudo usermod -aG $GROUPNAME $USERNAME
echo "Utente $USERNAME aggiunto al gruppo $GROUPNAME."

# 4. Creare un file accessibile solo all'utente
FILENAME="/home/$USERNAME/file_riservato.txt"
sudo touch $FILENAME
sudo chown $USERNAME:$USERNAME $FILENAME
sudo chmod 600 $FILENAME
echo "File $FILENAME creato e protetto: accesso riservato solo a $USERNAME."

# 5. Eliminare l'utente (con la sua home directory)
# (Comando commentato per sicurezza)
# sudo userdel -r $USERNAME
# echo "Utente $USERNAME eliminato."

########################################
# Altre operazioni utili:
########################################

# - Cambiare password a un utente:
# sudo passwd $USERNAME

# - Vedere a quali gruppi appartiene un utente:
# groups $USERNAME

# - Modificare il gruppo primario di un utente:
# sudo usermod -g nuovo_gruppo $USERNAME

# - Cambiare proprietario e gruppo di un file:
# sudo chown nuovo_utente:nuovo_gruppo nome_file

# - Dare permessi specifici su file o directory:
# chmod u+rwx nome_file    # utente
# chmod g+rw nome_file     # gruppo
# chmod o-r nome_file      # altri

# - Creare una directory accessibile solo a un gruppo:
# sudo mkdir /cartella_gruppo
# sudo chown :$GROUPNAME /cartella_gruppo
# sudo chmod 770 /cartella_gruppo

echo "Script completato. Ricordati di controllare i permessi e di testare ogni operazione!"
