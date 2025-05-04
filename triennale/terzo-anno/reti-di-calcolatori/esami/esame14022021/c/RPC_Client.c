/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include "RPC_xFile.h"
#include <rpc/rpc.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define DIM_BUFF 1024

int main(int argc, char *argv[]) {
    CLIENT         *clnt;

    // Output metodi RPC    
    OutputVisualizza   *out_1;
    int                *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static InputVisualizza      inp_1;
    static InputElimina         inp_2;

    /* CONTROLLO ARGOMENTI ---------------------------------- */
    if (argc < 2) {
        printf("Uso: %s <indirizzo server>\n", argv[0]);
        exit(1);
    }

    /* CREAZIONE STUB --------------------------------------- */
    clnt = clnt_create(argv[1], ESAME_PROG, ESAME_VERS, "tcp");
    if (clnt == NULL) {
        clnt_pcreateerror(argv[1]);
        exit(1);
    }

    /* LOGICA DI BUSINESS ----------------------------------- */
    /* Variabili -------------------------------------------- */
    char servizio[DIM_BUFF];
    int i;

    /* Ricevo fino ad eof ----------------------------------- */    
    printf("Servizi:  1= visualizza_prenotazioni, 2= elimina_monopattino\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* visualizza_prenotazioni ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("inserisci il nome brand: \n");
            gets(inp_1.marca);

            out_1 = visualizza_prenotazioni_1(&inp_1, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if ((out_1 -> numPrenotazioni) < 0 ) {
                printf("Brand non esiste sul server!\n");
            } else {
                for ( i = 0; i < out_1 -> numPrenotazioni ; i++ ){
                    printf("- %s\n", out_1 -> prenotazioni[i].id);
                }
            }

        }
        /* FINE visualizza_prenotazioni =================================== */
        /* -------------------------------------------------- */
        /* elimina_monopattino ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            gets(inp_2.id);

            out_2 = elimina_monopattino_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                printf("Risultato: %d\n", *out_2);
            }

        } 
        /* FINE elimina_monopattino =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi:  1= visualizza_prenotazioni, 2= elimina_monopattino\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}