/*
/// Author: Davide Chirichella
/// id: 0001071414
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
        strcpy(t[i].cartaId, "L");
        strcpy(t[i].marca, "L");
        strcpy(t[i].img, "L");
    }

    // Valori inizializati per i test
    strcpy(t[0].id, "CIAO12");
    strcpy(t[0].cartaId, "12345");
    strcpy(t[0].marca, "brand1");
        strcpy(t[0].img, "CIAO12_img/");

    strcpy(t[1].id, "CIAO23");
    strcpy(t[1].cartaId, "L");
    strcpy(t[1].marca, "brand2");
        strcpy(t[1].img, "CIAO23_img/");

    strcpy(t[2].id, "CIAO34");
    strcpy(t[2].cartaId, "11111");
    strcpy(t[2].marca, "brand3");
        strcpy(t[2].img, "CIAO34_img/");

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------+---------+\n");
    printf("| #  |   ID    | CartaID |  Marca  |   Img   |\n");
    printf("+----+---------+---------+---------+---------+\n");
    for (int i = 0; i < N; i++) {
        printf("| %d | %s | %s | %s | %s |\n",
               i,
               t[i].id,
               t[i].cartaId,
               t[i].marca,
               t[i].img
        );
    }
    printf("+----+---------+---------+---------+---------+\n");
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

OutputVisualizza *visualizza_prenotazioni_1_svc(InputVisualizza *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    static OutputVisualizza response;
    int i;
    response.numPrenotazioni = 0;

    /* Logica di business ------------------------------- */

    printf("\nVisualizzo pren. di %s\n", request->marca);
    if ( strcmp( request->marca, "brand1" ) == 0 || strcmp( request->marca, "brand2" ) == 0 ||strcmp( request->marca, "brand3" ) == 0 ){
        for (i = 0; i < N; i++) {
                printf("Trovato %s, confronto con %s\n", t[i].marca, request -> marca);
            if ( strcmp(t[i].marca, request->marca) == 0 && strcmp(t[i].cartaId, "L") != 0 && response.numPrenotazioni < 6 ) {
                response.prenotazioni[response.numPrenotazioni] = t[i];
                response.numPrenotazioni ++;
            }
        }
    } else {
        response.numPrenotazioni = -1;
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

int *elimina_monopattino_1_svc(InputElimina *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i;
    static int response = -1;

    /* Logica di business ------------------------------- */
    for (i = 0; i < N; i++) {
        if ( strcmp(t[i].id, request->id ) == 0 && strcmp(t[i].cartaId, "L" ) == 0  ){
            strcpy(t[i].id, "L");
            strcpy(t[i].cartaId, "L");
            strcpy(t[i].marca, "L");
            response = 0;
        }
    }
    /* Fine logica di business --------------------------- */

        // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------+---------+\n");
    printf("| #  |   ID    | CartaID |  Marca  |   Img   |\n");
    printf("+----+---------+---------+---------+---------+\n");
    for (i = 0; i < N; i++) {
        printf("| %d | %s | %s | %s | %s |\n",
               i,
               t[i].id,
               t[i].cartaId,
               t[i].marca,
               t[i].img
        );
    }
    printf("+----+---------+---------+---------+---------+\n");

    return (&response);
}
