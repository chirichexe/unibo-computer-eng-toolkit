/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include "esame.h"
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

int *conta_occorrenze_linea_1_svc(InputConta *request, struct svc_req *rqstp) {
    /* Variabili ---------------------------------------- */
    
    static int response;
    response = 0;
    char buffer[DIM_BUFF];
    int bytes_read;
    int uguale = 0;

    /* Logica di business ------------------------------- */

    printf("\nConto occorrenze di %s nel file %s\n", request->linea , request-> fileName);

    // Algoritmo ------------------------------------------------
    int fd = open(request-> fileName, O_RDONLY);
    if (fd < 0) {
        perror("Errore apertura file");
        response = -1;
        return (&response);
    }

    while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
        for (int i = 0; i < bytes_read; ++i) {
            char c = buffer[i];
            if (i <= sizeof(request -> linea) && request->linea[i] == c ) {
                uguale++;
            } else {
                uguale = 0;
                continue;
            }
            if (c == '\n') {
                if (uguale > 0) {
                    response++;
                }
            }
        }
    }

    if (bytes_read < 0) {
        perror("Errore lettura file");
        close(fd);
        response = -2;
        return (&response);
    }

    close(fd);

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputLista *lista_file_prefisso_1_svc(InputLista *request, struct svc_req *rqstp) {
    /* Variabili ---------------------------------------- */

    static OutputLista response;
    response.numFiles = 0;
    response.status = 0;
    struct dirent *entry;
    int presente;

    /* Logica di business ------------------------------- */

    printf("Listo file con prefisso %s dalla directory %s\n", request -> prefisso, request -> dirName);

    // Algoritmo -----------------------------------------------------
    DIR *dir = opendir(request -> dirName);
    if (dir == NULL) {
        perror("Errore nell'aprire la directory");
        response.status = -1;
        return (&response);
    }

    while ((entry = readdir(dir)) != NULL ) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        printf("Analizzo %s\n", entry->d_name);

        presente = 0;
        if (strncmp(entry->d_name, request -> prefisso, strlen(request -> prefisso)) == 0) {
            presente++;
        }

        if ( presente > 0 && response.numFiles <= MAX_LIST_SIZE ){
            strcpy(response.files[response.numFiles].nome, entry->d_name); 
            response.numFiles ++;
        }
    }
    closedir(dir);

    /* Fine logica di business --------------------------- */

    return (&response);
}
