/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

#include "files.h"
#include <dirent.h>
#include <fcntl.h>
#include <rpc/rpc.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define IS_TEXT(file_name) (file_name[strlen(file_name)-4] == '.' && file_name[strlen(file_name)-3] == 't' && file_name[strlen(file_name)-2] == 'x' && file_name[strlen(file_name)-1] == 't' ? 1 : 0)


/* ===== SERVIZIO 1: ELIMINA OCCORRENZE ===== */

//elimina le occorrenze all interno di un file, di una parola data da utente
OutputElimina *elimina_occorrenze_1_svc(InputElimina *request, struct svc_req *rqstp) {
    static OutputElimina response;
    response.numEliminati = 0;

    int bytes_read, write_index = 0, parola_index = 0;
    char buffer[1024];
    char nuovo_contenuto[1024];
    char parolabuffer[MAX_PAROLA + 1];

    int fd = open(request->fileName, O_RDWR, 0644);
    if (fd == -1) {
        perror("Errore nell'apertura del file");
        response.numEliminati = -1;
        return &response;
    }

    while ((bytes_read = read(fd, buffer, sizeof(buffer))) > 0) {
        for (int i = 0; i < bytes_read; i++) {
            char c = buffer[i];

            if (c != ' ' && c != '\n') {
                if (parola_index < MAX_PAROLA) {
                    parolabuffer[parola_index++] = c; // prima avviene assegnamento e poi si incrementa indice, come se il ++ ci fosse post asssegnamento
                }
            } else {
                if (parola_index > 0) {
                    parolabuffer[parola_index] = '\0';

                    if (strcmp(parolabuffer, request->parolaUtente) != 0) {
                        for (int j = 0; j < parola_index; j++) {
                            nuovo_contenuto[write_index++] = parolabuffer[j];
                        }
                    } else {
                        response.numEliminati++;
                    }

                    parola_index = 0;
                }

                // Aggiungo il separatore (spazio o newline)
                nuovo_contenuto[write_index++] = c;
            }
        }
    }

    // Gestisco eventuale parola finale
    if (parola_index > 0) {
        parolabuffer[parola_index] = '\0';
        if (strcmp(parolabuffer, request->parolaUtente) != 0) {
            for (int j = 0; j < parola_index; j++) {
                nuovo_contenuto[write_index++] = parolabuffer[j];
            }
        } else {
            response.numEliminati++;
        }
    }

    if (bytes_read < 0) {
        perror("Errore nella lettura del file");
        close(fd);
        response.numEliminati = -1;
        return &response;
    }

    lseek(fd, 0, SEEK_SET);
    if (ftruncate(fd, 0) == -1) {
        perror("Errore nel troncamento del file");
        close(fd);
        response.numEliminati = -1;
        return &response;
    }

    if (write(fd, nuovo_contenuto, write_index) == -1) {
        perror("Errore nella scrittura del file");
        close(fd);
        response.numEliminati = -1;
        return &response;
    }

    close(fd);
    return &response;
}
/* ===== SERVIZIO 1: ELIMINA OCCORRENZE ===== */
/*
OutputElimina *elimina_occorrenze_1_svc(InputElimina *request, struct svc_req *rqstp) {
    static OutputElimina response;
    response.numEliminati = 0;

    int bytes_read, write_index = 0, parola_index = 0;
    char buffer[1024];
    char nuovo_contenuto[1024];
    char parolabuffer[100];
    
    // Apertura file
    int fd = open(request->fileName, O_RDWR , 0644);
    if (fd == -1) {
        perror("Errore nell'apertura del file");
        response.numEliminati = -1;
        return (&response);
    }
    printf("File aperto con file descriptor: %d\n", fd);

    // Logica di business
    while ((bytes_read = read(fd, buffer, sizeof(buffer))) > 0) {
        for (ssize_t i = 0; i < bytes_read; i++) {
            

            if(buffer[i] != ' ' && buffer[i] != '\n'){
                parolabuffer[i] = buffer[i]; // i no
            }else{
                
                for(int j = 0; j < strlen(parolabuffer); j++){
                    if(parolabuffer[j] != request->parolaUtente[parola_index])
                        nuovo_contenuto[write_index++] = buffer[i];
                    else
                        response.numEliminati++;
                }
                memset(parolabuffer, 0, sizeof(parolabuffer));
                
            }

            // for(parola_index = 0; parola_index < MAX_PAROLA ; parola_index++){
                
            //     if (buffer[i] != request->parolaUtente[parola_index]) {
            //         nuovo_contenuto[write_index++] = buffer[i];
            //     } else {
            //         response.numEliminati++;
            //     }
            // }
            
        }
    }
    
    if (bytes_read < 0) {
        perror("Errore nella lettura del file di input");
        close(fd);
        response.numEliminati = -1;
        return (&response);
    }

    lseek(fd, 0, SEEK_SET);         // rewind del file 
    if (ftruncate(fd, 0) == -1) {   // rimuove contenuto precedente
        perror("Errore nel troncamento del file");
        close(fd);
        response.numEliminati = -1;
        return (&response);
    }

    ssize_t written = write(fd, nuovo_contenuto, write_index); // scrive il nuovo contenuto
    if (written == -1) {
        perror("Errore nella scrittura del file");
        close(fd);
        response.numEliminati = -1;
        return (&response);
    }

    // Chiusura file
    if (close(fd) == -1) {
        perror("Errore nella chiusura del file");
        response.numEliminati = -1;
        return (&response);
    }

    return (&response);
}
 */
/* ===== SERVIZIO 2: LISTA NOMI FILE ===== */

OutputLista *lista_nomifile_soglia_1_svc(InputLista *request, struct svc_req *rqstp) {

    static OutputLista response;

    int count = 0, ret, i, fd, numCaratteri;
    struct dirent *entry;
    struct stat          stat;
    char fullpath[256];
    char buffer[1024];

    // Apertura directory
    DIR *dir = opendir(request->dirName);
    if (dir == NULL) {
        perror("Errore nell'aprire la directory");
        response.status = -1;
        return (&response);
    }

    // Logica di business scorrendo i file
    response.numFile = 0;
    while ((entry = readdir(dir)) != NULL && response.numFile < MAX_FILE_LIST) {

        // Salta file nascosti e directory speciali (per evitare il continuo meti in un if e metti negato)
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        snprintf(fullpath, sizeof(fullpath), "%s/%s", request->dirName, entry->d_name);
        
        if (stat(fullpath, &stat) == -1) {
            perror("Errore nel fare stat sul file");
            continue;
        }

        if ( !S_ISREG(stat.st_mode)) {
            continue; // ignora se non è file regolare
        }

        printf("Analizzo %s\n", entry->d_name);

         // Apertura file
        int fd = open(fullpath, O_RDWR , 0644);
        if (fd == -1) {
            perror("Errore nell'apertura del file");
            //response.numEliminati = -1;
            return (&response);
        }
        printf("File aperto con file descriptor: %d\n", fd);

        // Logica di business
        //alternativa a lettura di bytes con lseek piu sicuro che legge proprio la dim
        // Ottieni dimensione con lseek()
        off_t file_size = lseek(fd, 0, SEEK_END);
        if (file_size == -1) {
            perror("Errore con lseek");
            close(fd);
            continue;
        }

        lseek(fd, 0, SEEK_SET);  // Torna all'inizio, in caso ti serva leggere dopo

        int isText = IS_TEXT(entry->d_name);

        if ((isText && file_size < request->soglia) ||
            (!isText && file_size > request->soglia)) {
            strncpy(response.nomiFile[response.numFile].name, entry->d_name, MAX_FILE_NAME - 1);
            response.nomiFile[response.numFile].name[MAX_FILE_NAME - 1] = '\0';
            response.numFile++;
        }
        

        /*
        // Logica di business
        bytes_read = read(fd, buffer, sizeof(buffer));

        if(IS_TEXT(entry->d_name) && bytes_read < request->soglia){
            strncpy(response.nomiFile[response.numFile].name, entry->d_name, sizeof(response.nomiFile[response.numFile].name) - 1);
            response.nomiFile[response.numFile].name[sizeof(response.nomiFile[response.numFile].name) - 1] = '\0'; // assicura terminatore
            response.numFile++;
        }else if(!IS_TEXT(entry->d_name) && bytes_read > request->soglia){
            strncpy(response.nomiFile[response.numFile].name, entry->d_name, sizeof(response.nomiFile[response.numFile].name) - 1);
            response.nomiFile[response.numFile].name[sizeof(response.nomiFile[response.numFile].name) - 1] = '\0'; // assicura terminatore
            response.numFile++;
        }*/


        /*
        // Conta le occorrenze del carattere nel nome del file
        int numCaratteri = 0;
        for (int i = 0; entry->d_name[i] != '\0'; i++) {

            // Confronta il carattere ignorando maiuscole/minuscole
            if (tolower(entry->d_name[i]) == tolower(request->carattere)) {
                numCaratteri++;
            }
        }

        // Se il numero di occorrenze soddisfa il requisito, aggiungi il nome all'array
        if (numCaratteri >= request->numOccorrenze) {
            strncpy(response.nomiFile[response.numFile].name, entry->d_name, sizeof(response.nomiFile[response.numFile].name) - 1);
            response.nomiFile[response.numFile].name[sizeof(response.nomiFile[response.numFile].name) - 1] = '\0'; // assicura terminatore
            response.numFile++;
        }
        */
        // Pulisce la stringa
        //memset(fullpath, 0, sizeof(fullpath));
        
        close(fd);
    }

    closedir(dir);
    return (&response);

}