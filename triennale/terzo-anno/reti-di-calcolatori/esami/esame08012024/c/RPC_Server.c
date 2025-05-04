/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
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

/* ===== SERVIZIO 1: ELIMINA OCCORRENZE ===== */

OutputElimina *elimina_occorrenze_1_svc(InputElimina *request, struct svc_req *rqstp) {
    static OutputElimina response;
    response.numEliminati = 0;

    int bytes_read, write_index = 0;
    char buffer[1024];
    char nuovo_contenuto[1024];
    
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
            if (!((buffer[i] >= 'a' && buffer[i] <= 'z') || (buffer[i] >= 'A' && buffer[i] <= 'Z'))) {
                nuovo_contenuto[write_index++] = buffer[i];
            } else {
                response.numEliminati++;
            }
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

/* ===== SERVIZIO 2: LISTA NOMI FILE ===== */

OutputLista *lista_file_carattere_1_svc(InputLista *request, struct svc_req *rqstp) {

    static OutputLista response;

    int count = 0, ret, i, fd_file, numCaratteri;
    struct dirent *entry;
    struct stat          stat;
    char fullpath[256];

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

        snprintf(fullpath, sizeof(fullpath), "%s/%s", request->dirName, entry->d_name);
        
        if ( S_ISREG(stat.st_mode)) {
            continue;
        }

        printf("Analizzo %s\n", entry->d_name);

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

        // Pulisce la stringa
        memset(fullpath, 0, sizeof(fullpath));
        closedir(dir);
    }

    return (&response);

}