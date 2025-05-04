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

static int  inizializzato = 0;


/********************************************************/

/* Inizializza lo stato del server -------------------- */
void inizializza() {
    int i;
    if (inizializzato == 1) {
        return;
    }

    // Inizializzato tutto come vuoto
    for (i = 0; i < N; i++) {
        strcpy(t[i].matricola, "-");
        strcpy(t[i].nome, "-");
        strcpy(t[i].cognome, "-");
        t[i].voto = -1;
    }

    // Valori inizializati per i test
    strcpy(t[0].matricola, "00012345");
    strcpy(t[0].nome, "Davide");
    strcpy(t[0].cognome, "Chirichella");
    t[0].voto = 28;

    strcpy(t[1].matricola, "00012346");
    strcpy(t[1].nome, "Antonio");
    strcpy(t[1].cognome, "Corradi");
           t[1].voto = 30;

    strcpy(t[2].matricola, "00010714");
    strcpy(t[2].nome, "Armir");
    strcpy(t[2].cognome, "Bujari");
           t[2].voto = -1;

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *servizio1_1_svc(Matricola *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    static int response;
    response = -1;

    /* Logica di business ------------------------------- */

    printf("\nElimino voto matricola %s\n", request->matricola);
    for (int i = 0; i < N; i++) {
        if ( strcmp(t[i].matricola, request->matricola ) == 0 ){
            strcpy(t[i].matricola, "-");
            strcpy(t[i].nome, "-");
            strcpy(t[i].cognome, "-");
            t[i].voto = -1;
            response = 0;
            break;
        }
    }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

OutputSoglia *servizio2_1_svc(int *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */

    static OutputSoglia response;
    response.numMatricole = 0;

    /* Logica di business ------------------------------- */
    for (int i = 0; i < MAX_LIST_SIZE; i++) {
        strcpy(response.matricole[i].matricola, "-");
    }

    printf("Cerco voto superiore a %d\n", *request);

    for (int i = 0; i < N; i++) {
        if (t[i].voto >= *request && response.numMatricole < MAX_LIST_SIZE) {
            strcpy(response.matricole[response.numMatricole].matricola, t[i].nome);
            response.numMatricole++;
        }
    }
    /* Fine logica di business --------------------------- */

    return (&response);
}
