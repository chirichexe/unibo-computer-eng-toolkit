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
        strcpy(t[i].id, "L");
        strcpy(t[i].data, "-1/-1/-1");
               t[i].giorni = -1;
        strcpy(t[i].modello, "-1");
               t[i].costo = -1;
        strcpy(t[i].foto, "L");
    }

    // Valori inizializati per i test
    strcpy(t[0].id, "id1");
    strcpy(t[0].data, "10/22/2003");
           t[0].giorni = 1;
    strcpy(t[0].modello, "Mod1");
           t[0].costo = 2;
    strcpy(t[0].foto, "id1_img");

    strcpy(t[1].id, "id2");
    strcpy(t[1].data, "10/12/2024");
           t[1].giorni = 3;
    strcpy(t[1].modello, "Mod2");
           t[1].costo = 3;
    strcpy(t[1].foto, "id2_img");

    strcpy(t[2].id, "id3");
    strcpy(t[2].data, "-1/-1/-1");
           t[2].giorni = -1;
    strcpy(t[2].modello, "Mod3");
           t[2].costo = 4;
    strcpy(t[2].foto, "id3_img");


    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa per test
    printf("|#\t|id\t|data\t|giorni\t|modello\t|costo\t|foto\t|\n");
    for (i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|%s\t|%d\t|%s\t|\n",
               i,
               t[i].id,
               t[i].data,
               t[i].giorni,
               t[i].modello,
               t[i].costo,
               t[i].foto
        );
    }
    // Fine stampa per test
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *elimina_sci_1_svc(InputElimina *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i;
    static int response = -1;

    /* Logica di business ------------------------------- */

    printf("\nElimina_sci: Richiesto %s\n", request->id);

    for (i = 0; i < N; i++) {
        if ( strcmp(t[i].id, request->id) == 0 ) {
            
            // Elimina file
            if (unlink(t[i].foto) < 0) {
                perror("unlink");
            }

            // Elimina lo sci dalla struttura dati
            strcpy(t[i].id, "L");
            strcpy(t[i].data, "-1/-1/-1");
                t[i].giorni = -1;
            strcpy(t[i].modello, "-1");
                t[i].costo = -1;
            strcpy(t[i].foto, "L");

            response = 1;
        }
    }

    printf("|#\t|id\t|data\t|giorni\t|modello\t|costo\t|foto\t|\n");
    for ( i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|%s\t|%d\t|%s\t|\n",
               i,
               t[i].id,
               t[i].data,
               t[i].giorni,
               t[i].modello,
               t[i].costo,
               t[i].foto
        );
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

int *noleggia_sci_1_svc(InputNoleggia *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    static int response = -1;
    int i;

    /* Logica di business ------------------------------- */

    printf("Noleggia_sci: Richiesto %s %s %d\n", request->id, request->data, request->giorni);

    for (i = 0; i < N; i++) {
        if (strcmp(request->id, t[i].id) == 0 && t[i].giorni < 0 ){
            strcpy(t[i].data, request->data);
                   t[i].giorni = request->giorni;

            response = 1;

        }
    }

    printf("Aggiornata:\n|#\t|id\t|data\t|giorni\t|modello\t|costo\t|foto\t|\n");
    for (i = 0; i < N; i++) {
            printf("|%d\t|%s\t|%s\t|%d\t|%s\t|%d\t|%s\t|\n",
               i,
               t[i].id,
               t[i].data,
               t[i].giorni,
               t[i].modello,
               t[i].costo,
               t[i].foto
        );
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}
