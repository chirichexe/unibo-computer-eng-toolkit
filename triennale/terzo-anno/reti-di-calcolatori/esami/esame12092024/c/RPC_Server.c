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

#define N 12 // Numero massimo studenti con voto > soglia

/*STATO INTERNO PRIVATO DEL SERVER*/
typedef struct {
    char matricola[MAX_DIM_NAME];
    char nome[MAX_DIM_NAME];
    char cognome[MAX_DIM_NAME];
    int voto;
} Riga;

// variabili globali private (static)
static Riga t[N];
static int  inizializzato = 0;

/* Inizializza lo stato del server */
void inizializza() {
    int i;
    if (inizializzato == 1) {
        return;
    }

    // Tutti inizialmente liberi
    for (i = 0; i < N; i++) {
        strcpy(t[i].matricola, "-");
        strcpy(t[i].nome, "-");
        strcpy(t[i].cognome, "-");
        t[i].voto = -1;
    }

    // Inizializziamo qualche valore per i test
    strcpy(t[0].matricola, "00012345");
    strcpy(t[0].nome, "Davide");
    strcpy(t[0].cognome, "Pluto");
    t[0].voto = 28;

    strcpy(t[1].matricola, "00012346");
    strcpy(t[1].nome, "Filomena");
    strcpy(t[1].cognome, "Romano");
           t[1].voto = 30;

    strcpy(t[2].matricola, "00010714");
    strcpy(t[2].nome, "aa");
    strcpy(t[2].cognome, "Chirichella");
           t[2].voto = -1;

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");
}

/* ===== SERVIZIO 1 ===== */

int *elimina_prenotazione_1_svc(Matricola *request, struct svc_req *rqstp) {
    if (inizializzato == 0) {
        inizializza();
    }

    static int response;
    response = -1;

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

    return (&response);
}

/* ===== SERVIZIO 2 ===== */

OutputSoglia *visualizza_voto_maggiore_soglia_1_svc(int *request, struct svc_req *rqstp) {

    if (inizializzato == 0) {
        inizializza();
    }

    static OutputSoglia response;
    response.numMatricole = 0;

    // Inizializza tutte le matricole
    for (int i = 0; i < MAX_DIM_LIST; i++) {
        strcpy(response.matricole[i].matricola, "-");
    }

    printf("Cerco voto superiore a %d\n", *request);

    for (int i = 0; i < N; i++) {
        if (t[i].voto >= *request && response.numMatricole < MAX_DIM_LIST) {
            strcpy(response.matricole[response.numMatricole].matricola, t[i].nome);
            response.numMatricole++;
        }
    }

    return (&response);
}
