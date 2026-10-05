/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

// BALLOTTI MATTIA 0001077835

#include "RPC_xFile.h"
#include <dirent.h>
#include <fcntl.h>
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
        strcpy(t[i].targa, "L");
        strcpy(t[i].patente, "0");
        strcpy(t[i].tipo, "L");
        strcpy(t[i].img, "L");
    }

    // Valori inizializati per i test
    strcpy(t[0].targa, "ED000AA");
    strcpy(t[0].patente, "22445");
    strcpy(t[0].tipo, "auto");
    strcpy(t[0].img, "ED000AA_img/");

    strcpy(t[1].targa, "KO041AA");
    strcpy(t[1].patente, "99887");
    strcpy(t[1].tipo, "camper");
    strcpy(t[1].img, "KO041AA_img/");

    strcpy(t[2].targa, "CA550OO");
    strcpy(t[2].patente, "01234");
    strcpy(t[2].tipo, "auto");
    strcpy(t[2].img, "CA550OO_img/");

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------------+------+\n");
    printf("| #  |  Targa  | Patente |      Img      | Tipo |\n");
    printf("+----+---------+---------+---------------+------+\n");
    for (int i = 0; i < N; i++) {
        printf("| %d | %s |   %s  | %s | %s |\n",
               i,
               t[i].targa,
               t[i].patente,
               t[i].img,
               t[i].tipo
        );
    }
    printf("+----+---------+---------+---------------+------+\n");
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

    printf("\nVisualizzo pren. di %s\n", request->tipo);
    if ( strcmp( request->tipo, "auto" ) == 0 || strcmp( request->tipo, "camper" ) == 0){
        for (i = 0; i < N; i++) {
                printf("Trovato %s, confronto con %s\n", t[i].tipo, request -> tipo);
            if ( strcmp(t[i].tipo, request->tipo) == 0 && strcmp(t[i].targa, "L") != 0 && strncmp(t[i].targa, "ED", 2) >= 0 && response.numPrenotazioni < 6 ) {
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

int *aggiorna_licenza_1_svc(InputAggiorna *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i;
    static int response = -1;

    /* Logica di business ------------------------------- */
    for (i = 0; i < N; i++) {
        if (strcmp(t[i].targa, request->targa ) == 0){
            strcpy(t[i].patente, request->patente);
            response = 0;
        }
    }
    /* Fine logica di business --------------------------- */
	
    // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------------+------+\n");
    printf("| #  |  Targa  | Patente |      Img      | Tipo |\n");
    printf("+----+---------+---------+---------------+------+\n");
    for (int i = 0; i < N; i++) {
        printf("| %d | %s |   %s  | %s | %s |\n",
               i,
               t[i].targa,
               t[i].patente,
               t[i].img,
               t[i].tipo
        );
    }
    printf("+----+---------+---------+---------------+------+\n");

    return (&response);
}
