/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

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
#define IS_NUMERIC(c) ((c) >= '0' && (c) <= '9')
#define IS_TEXT(file_name) (file_name[strlen(file_name)-4] == '.' && file_name[strlen(file_name)-3] == 't' && file_name[strlen(file_name)-2] == 'x' && file_name[strlen(file_name)-1] == 't' ? 1 : 0)


/********************************************************/
/* SERVIZIO 1 ========================================== */

int *elimina_occorrenze_1_svc(FileName *request, struct svc_req *rqstp) {
    printf("\nelimina_occorrenze: Richiesto %s\n", request->filename);

    /* Variabili ---------------------------------------- */

    int i;
    static int response = 0;
    char buffer[DIM_BUFF], filename[DIM_BUFF];
    int fd, temp_fd;
    int bytes_read;

    /* Logica di business ------------------------------- */
    // Apertura file;
    fd = open(request->filename, O_RDONLY);
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
            if ( !IS_NUMERIC(buffer[i]) ) { // condizione di scrittura
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
    if (rename(temp_filename, request->filename) < 0) {
        perror("rename");
        unlink(temp_filename);
        response = -2;
        return (&response);
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputLista *lista_sottodirettori_1_svc(DirName *request, struct svc_req *rqstp) {
    printf("\nlista_sottodirettori: Richiesto %s\n", request->dirname);

    /* Variabili ---------------------------------------- */
    
    static OutputLista response;
    response.dimLista = 0;
    int i;

    /* Logica di business ------------------------------- */

    // SCORRE LE SOTTODIRECTORY ================================== SNIPPET
    // Variabili (sposta sopra) --------------------------------------
    int fd_file;
    int valida;
    struct dirent *entry;
    struct dirent *subentry;
    char fullpath[MAX_NAME_SIZE * 2];
    char dirpath[MAX_NAME_SIZE * 2];
    char buffer[DIM_BUFF];
    int bytes_read;
    int num_files;
    int fd;
    DIR *dir;
    DIR *subdir;

    // Algoritmo -----------------------------------------------------
    dir = opendir(request->dirname);
    if (dir == NULL) {
        perror("opendir");
        response.dimLista = -1;
    } else {
        // Scorre la directory inserita
        while ((entry = readdir(dir)) != NULL) {
            if (entry->d_type == DT_DIR && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {

                snprintf(dirpath, sizeof(dirpath), "%s/%s", request->dirname, entry->d_name);
                printf("Trovata sottodirectory %s\n", dirpath);

                subdir = opendir(dirpath);
                if (subdir == NULL) {
                    perror("opendir");
                    continue;
                }

                // Scorre le sottodirectory
                valida = 1;
                num_files = 0;
                while ((subentry = readdir(subdir)) != NULL) {
                    if (strcmp(subentry->d_name, ".") != 0 && strcmp(subentry->d_name, "..") != 0) {
                        snprintf(fullpath, sizeof(fullpath), "%s/%s", dirpath, subentry->d_name);
                        printf("\tFile trovato: %s\n", fullpath);

                        // Analizzo file ------------------------------------
                        
                        fd = open(fullpath, O_RDONLY);
                        if (fd < 0) {
                            perror("Errore apertura file");
                            continue;
                        }

                        // Condizioni di validità
                        if ( IS_TEXT(subentry -> d_name)){
                            num_files++;
                        }

                        while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                            for (i = 0; i < bytes_read; i++ ) {
                                if (buffer[i] > 127){
                                    valida = 0;
                                    printf("FALSE\n");
                                    break;
                                }
                            }
                        }

                        if (bytes_read < 0) {
                            perror("Errore lettura file");
                            close(fd);
                            continue;
                        }

                        close(fd);

                        // File analizzato ----------------------------------
                    }
                }
                closedir(subdir);


                // Salva il nome della directory nella lista se è valida
                if (valida && num_files >= 2){
                    strcpy(response.elementi[response.dimLista].dirname, entry->d_name);
                    response.dimLista++;
                }
            }
        }
        closedir(dir);
    }
    // FINE SCORRE LE SOTTODIRECTORY ============================== SNIPPET

    /* Fine logica di business --------------------------- */

    return (&response);
}
