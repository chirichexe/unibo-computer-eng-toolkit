//CHIRICHELLA DAVIDE 0001071414

#include "RPC_xFile.h"
#include <dirent.h>
#include <fcntl.h>
#include <rpc/rpc.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DIM_BUFF 1024

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *servizio1_1_svc(InputM1 *request, struct svc_req *rqstp) {
    printf("\nSERVIZIO1: Richiesto %s\n", request->elemento1);

    /* Variabili ---------------------------------------- */

    int i;
    static int response = 0;

    /* Logica di business ------------------------------- */

    /* SOSTITUZIONE CARATTERI ============================ SNIPPET */
    // Variabili (spostare sopra) ----------------------------------
    char buffer[DIM_BUFF], filename[DIM_BUFF];
    int fd, temp_fd;
    int bytes_read;

    // Algoritmo ------------------------------------------------
    // Apertura file;
    fd = open(request->elemento1, O_RDONLY);
    if (fd < 0) {
        perror("open");
        response = -1;
        return (&response);
    }

    // Creazione file temporaneo
    char temp_filename[] = "/tmp/tempfileXXXXXX";
    temp_fd = mkstemp(temp_filename);
    if (temp_fd < 0) {
        perror("creazione file temporaneo");
        close(fd);
        response = -1;
        return (&response);
    }

    // Scorro il contenuto
    response = 0;
    while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
        for ( i = 0; i < bytes_read; ++i) {
            if (buffer[i] != 'a' ) { // condizione di scrittura
                if (write(temp_fd, &buffer[i], 1) < 0) {
                    perror("write");
                    close(fd);
                    close(temp_fd);
                    unlink(temp_filename);
                    response = -2;
                    return (&response);
                }
            } else { // conto quelli non scritti
                response ++;
            }
        }
    }

    if (bytes_read < 0) {
        perror("read");
        close(fd);
        close(temp_fd);
        unlink(temp_filename);
        response = -2;
        return (&response);
    }

    close(fd);
    close(temp_fd);

    // Rinomino il file temporaneo
    if (rename(temp_filename, request->elemento1) < 0) {
        perror("rename");
        unlink(temp_filename);
        response = -2;
        return (&response);
    }
    /* FINE SOSTITUZIONE CARATTERI ======================= SNIPPET */


    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputM2 *servizio2_1_svc(InputM2 *request, struct svc_req *rqstp) {
    printf("\nSERVIZIO2: Richiesto %s\n", request->elemento2);

    /* Variabili ---------------------------------------- */
    
    static OutputM2 response;
    response.dimLista = 0;
    int i;

    /* Logica di business ------------------------------- */

    // SCORRE UNA DIRECTORY ================================== SNIPPET
    // Variabili (sposta sopra) --------------------------------------
    int fd_file;
    struct dirent *entry;
    char fullpath[MAX_NAME_SIZE * 2];
    DIR *dir;

    // Algoritmo -----------------------------------------------------
    dir = opendir(request->elemento2);
    if (dir == NULL) {
        perror("Errore nell'aprire la directory");
        response.dimLista = -1;
    } else {
        while ((entry = readdir(dir)) != NULL ) {
            if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                continue;
            }
            snprintf(fullpath, sizeof(fullpath), "%s/%s", request->elemento2, entry->d_name);
            printf("Analizzo %s\n", entry->d_name);
            
            // CONTA LINEE CARATTERE SOGLIA ====================== SNIPPET
            // Variabili (sposta sopra) ----------------------------------
            char buffer[DIM_BUFF];
            int bytes_read;
            int line_count = 0;
            int fd, count = 0;

            char carattere = 'a';
            int soglia = 5;

            // Algoritmo ------------------------------------------------
            fd = open(fullpath, O_RDONLY);
            if (fd < 0) {
                perror("Errore apertura file");
                response.dimLista = -1;
                return (&response);
            } 

            while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                for ( i = 0; i < bytes_read; i++ ) {
                    char c = buffer[i];
                    if (tolower(c) == carattere) { // condizione sulla riga
                        count++;
                    }
                    if (c == '\n') {
                        if (count >= soglia && response.dimLista <= MAX_LIST_SIZE ) { // condizione di aggiunta
                            line_count++;
                            // li aggiungo alla lista
                            strcpy(response.elementi[response.dimLista].filename, entry->d_name);
                            response.dimLista ++;
                        }
                        count = 0;
                    }
                }
            }

            if (bytes_read < 0) {
                perror("Errore lettura file");
                close(fd);
                response.dimLista = -2;
                return (&response);
            }

            close(fd);
            printf("Numero di righe con almeno N CARATTERI: %d\n", line_count);

            // FINE CONTA LINEE CARATTERE SOGLIA ================= SNIPPET

            // Pulisce la stringa
            memset(fullpath, 0, sizeof(fullpath));
        }
        closedir(dir);
    }

    // FINE SCORRE UNA DIRECTORY ============================== SNIPPET

    /* Fine logica di business --------------------------- */

    return (&response);
}
