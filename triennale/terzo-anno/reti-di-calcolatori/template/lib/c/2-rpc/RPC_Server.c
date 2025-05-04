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

static int  inizializzato = 0;
/********************************************************/
static Riga t[N];

/* Inizializza lo stato del server -------------------- */
void inizializza() {
    int i;
    if (inizializzato == 1) {
        return;
    }

    // Inizializzato tutto come vuoto
    for (i = 0; i < N; i++) {
        strcpy(t[i].DATO1, "L");
        strcpy(t[i].DATO2, "L");
               t[i].DATO3 = -1;
    }

    // Valori inizializati per i test
    strcpy(t[0].DATO1, "DATO1_1");
    strcpy(t[0].DATO2, "12345");
           t[0].DATO3 = 1;

    strcpy(t[1].DATO1, "DATO2_2");
    strcpy(t[1].DATO2, "12346");
           t[1].DATO3 = 1;

    strcpy(t[2].DATO1, "DATO3_3");
    strcpy(t[2].DATO2, "12347");
           t[2].DATO3 = 1;

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa per test
    printf("|#\t|DATO1\t|DATO2\t|DATO2\t|\n");
    for (int i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|\n",
               i,
               t[i].DATO1,
               t[i].DATO2,
               t[i].DATO3
        );
    }
    // Fine stampa per test
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *servizio1_1_svc(InputM1 *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i;
    static int response = -1;

    /* Logica di business ------------------------------- */

    printf("\nSERVIZIO1: Richiesto %s\n", request->elemento1);

    printf("|#\t|DATO1\t|DATO2\t|DATO2\t|\n");
    for (int i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|\n",
               i,
               t[i].DATO1,
               t[i].DATO2,
               t[i].DATO3
        );
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputM2 *servizio2_1_svc(InputM2 *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    static OutputM2 response;
    response.dimLista = 0;
    int i;

    /* Logica di business ------------------------------- */

    printf("\nSERVIZIO2: Richiesto %s\n", request->elemento2);

    printf("|#\t|DATO1\t|DATO2\t|DATO2\t|\n");
    for (int i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|\n",
               i,
               t[i].DATO1,
               t[i].DATO2,
               t[i].DATO3
        );

        // Controllo del criterio
        if (strcmp(t[i].DATO1, request->elemento2) == 0) {
            if (response.dimLista < MAX_LIST_SIZE) {
    
                response.risultato[response.dimLista] = t[i];

                /*OPPURE
                strcpy(response.risultato[response.dimLista].DATO1, t[i].DATO1);
                strcpy(response.risultato[response.dimLista].DATO2, t[i].DATO2);
                response.risultato[response.dimLista].DATO3 = t[i].DATO3;
                */
                
                response.dimLista++;
            }
        }
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}
