/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
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
        strcpy(t[i].data, "-1/-1/-1");
        strcpy(t[i].giorni, "-1");
        strcpy(t[i].modello, "-1");
        strcpy(t[i].costoG, "-1");
        strcpy(t[i].nomeFileFoto, "L");
    }

    // Valori inizializati per i test
    strcpy(t[0].id, "test1");
    strcpy(t[0].data, "12/12/2012");
    strcpy(t[0].giorni, "2");
    strcpy(t[0].modello, "voki");
    strcpy(t[0].costoG, "4");
    strcpy(t[0].nomeFileFoto, "CIAO12.jpg");

     strcpy(t[1].id, "test2");
    strcpy(t[1].data, "12/12/2013");
    strcpy(t[1].giorni, "3");
    strcpy(t[1].modello, "volpi");
    strcpy(t[1].costoG, "8");
    strcpy(t[1].nomeFileFoto, "CIAO23.jpg");

    strcpy(t[2].id, "test3");
    strcpy(t[2].data, "12/12/2010");
    strcpy(t[2].giorni, "2");
    strcpy(t[2].modello, "caosa");
    strcpy(t[2].costoG, "6");
    strcpy(t[2].nomeFileFoto, "CIAO34.jpg");

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");

    // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------+---------+-----------\n");
    printf("| #  |   ID    | data |  giorni  |   modello   |   costoG |\n");
    printf("+----+---------+---------+---------+---------+------------\n");
    for (int i = 0; i < N; i++) {
        printf("| %d | %s | %s | %d | %s | %d | %s\n",
               i,
               t[i].id,
               t[i].data,
               t[i].giorni,
               t[i].modello,
               t[i].costoG,
               t[i].nomeFileFoto
        );
    }
    printf("+----+---------+---------+---------+---------+\n");
}

/********************************************************/
/* SERVIZIO 1 ========================================== */

int *noleggia_sci_1_svc(InputVisualizza *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    
    //static OutputVisualizza response;
    int i, response = -1;
    // response.numPrenotazioni = 0;

    /* Logica di business ------------------------------- */

    printf("\nVisualizzo pren. di %s\n", request->id);
    
    for (i = 0; i < N; i++) {
        printf("Trovo %s e confronto con %s\n", request -> id,t[i].id);
        //&& response.numPrenotazioni < 6 
        if ( strcmp(t[i].id, request->id) == 0 && strcmp(t[i].data, "-1/-1/-1") != 0 && strcmp(t[i].giorni, "-1")) {
           
            strcpy(t[i].id, request->id);
            // o snprintf(t[i].data, sizeof(t[i].data), "%s/%s/%s", request->giorni, request->mese, request->anno);

            strcpy(t[i].data, request->giorni);
            strcat(t[i].data, "/");
            strcat(t[i].data, request->mese);
            strcat(t[i].data, "/");
            strcat(t[i].data, request->anno);
            strcpy(t[i].giorni, request->giorniDurata);
            
            response = 1;
            // response.prenotazioni[response.numPrenotazioni] = t[i];
            // response.numPrenotazioni ++;
        }
    }

    
    // if ( strcmp( request->marca, "brand1" ) == 0 || strcmp( request->marca, "brand2" ) == 0 ||strcmp( request->marca, "brand3" ) == 0 ){
        
    // } else {
    //     response.numPrenotazioni = -1;
    // }

    /* Fine logica di business --------------------------- */

    return (&response);
}

/* SERVIZIO 2 ========================================== */

int *elimina_sci_1_svc(InputElimina *request, struct svc_req *rqstp) {
    // Inizializzazione se non avvenuta
    if (inizializzato == 0) {
        inizializza();
    }

    /* Variabili ---------------------------------------- */
    int i;
    static int response = -1;
    char fotoName[MAX_NAME_SIZE];

    /* Logica di business ------------------------------- */
    //&& strcmp(t[i].cartaId, "L" ) == 0  
    for (i = 0; i < N; i++) {
        if ( strcmp(t[i].id, request->id ) == 0 ){

            if (unlink(t[i].nomeFileFoto) == -1) {
            perror("Errore nella rimozione del file");
           
            }

            strcpy(t[i].id, "L");
            strcpy(t[i].data, "-1/-1/-1");
            strcpy(t[i].giorni, "-1");
            strcpy(t[i].modello, "-1");
            strcpy(t[i].costoG, "-1");
            strcpy(t[i].nomeFileFoto, "L");

            response = 1;
        }
    }
    /* Fine logica di business --------------------------- */


        // Stampa in formato tabellare
    printf("Tabella:\n");
    printf("+----+---------+---------+---------+---------+\n");
   // printf("| #  |   ID    | CartaID |  Marca  |   Img   |\n");
    printf("+----+---------+---------+---------+---------+\n");
    for (i = 0; i < N; i++) {
         printf("| %d | %s | %s | %d | %s | %d | %s\n",
               i,
               t[i].id,
               t[i].data,
               t[i].giorni,
               t[i].modello,
               t[i].costoG,
               t[i].nomeFileFoto
        );
    }
    printf("+----+---------+---------+---------+---------+\n");

    return (&response);
}
