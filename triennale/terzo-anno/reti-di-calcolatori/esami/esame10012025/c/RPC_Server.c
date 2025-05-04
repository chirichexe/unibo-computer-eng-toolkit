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
#define N 10
#define M 5

static int  inizializzato = 0;
/********************************************************/
static Matricola t[N][M];

/* Inizializza lo stato del server -------------------- */
void inizializza() {
    int i,j;
    if (inizializzato == 1) {
        return;
    }

    // Inizializzato tutto come vuoto
    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            strcpy(t[i][j].matricola, "L");
        }
    }

    // Valori inizializati per i test
    strcpy(t[0][0].matricola, "0001071414");
    strcpy(t[0][1].matricola, "0001071413");


    strcpy(t[1][0].matricola, "0001071414");
    strcpy(t[1][2].matricola, "0001071418");

    strcpy(t[2][1].matricola, "0001071412");
    strcpy(t[3][1].matricola, "0001071412");

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa per test
    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            printf("|%s\t", t[i][j].matricola);
        }
        printf("|\n");
    }
    // Fine stampa per test
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *elimina_prenotazione_1_svc(InputElimina *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i, j;
    int fd_file;
    struct dirent *entry;
    char fullpath[MAX_NAME_SIZE * 2];
    DIR *dir;
    char dirname[MAX_NAME_SIZE];
    static int response = 0;

    /* Logica di business ------------------------------- */

    printf("\nelimina_prenotazione: Richiesto %s\n", request->matricola);

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            if ( strcmp(t[i][j].matricola, request->matricola ) == 0 ){
                // Elimino elemento
                strcpy(t[i][j].matricola, "L");

                strcpy(dirname, request->matricola);
                strcat(dirname, "_img/");
                printf("Elimino dir %s\n", dirname);

                // Svuoto la directory
                dir = opendir(dirname);
                if (dir == NULL) {
                    perror("opendir");
                } else {
                    while ((entry = readdir(dir)) != NULL ) {
                        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                            continue;
                        }
                        
                        snprintf(fullpath, sizeof(fullpath), "%s%s", dirname, entry->d_name);
                        printf("Rimuovo immagine %s\n", fullpath);

                        if ( unlink(fullpath) < 0 ){
                            perror("unlink");
                            closedir(dir);
                            response = -1;
                            return (&response);
                        }                        
                    }
                    closedir(dir);

                    // Elimino directory
                    if (rmdir(dirname) < 0 ) {
                        perror("rmdir");
                        response = -1;
                        return (&response);
                    }
                }
                
                response ++;
            }
        }
    }
    
    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            printf("|%s\t", t[i][j].matricola);
        }
        printf("|\n");
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputVisualizza *visualizza_multiple_1_svc(void *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    static OutputVisualizza response;
    response.dimLista = 0;
    int i, j;

    /* Logica di business ------------------------------- */

    printf("\nvisualizza_multiple\n");

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            printf("|%s\t", t[i][j].matricola);
        }
        printf("|\n");
    }

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            if ( strcmp(t[i][j].matricola, "L") != 0 && 
                strcmp(t[i][j].matricola, t[i+1][j].matricola) == 0 && strcmp(t[i][j].matricola, t[i+1][j].matricola) == 0 
                && response.dimLista < MAX_LIST_SIZE )
            {
                printf("Trovato %s %d %d\n", t[i][j].matricola, i, j );
                strcpy(response.risultato[response.dimLista].matricola, t[i][j].matricola);
                response.dimLista++;
            }
        }
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}
