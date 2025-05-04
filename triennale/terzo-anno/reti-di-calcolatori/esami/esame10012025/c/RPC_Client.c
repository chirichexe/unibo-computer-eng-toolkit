//CHIRICHELLA DAVIDE 0001071414

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
    int         *out_1;
    OutputVisualizza    *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static InputElimina      inp_1;
    void *inp_2;

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
    printf("Servizi:  1 = elimina_prenotazione, 2 = visualizza_multiple\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* elimina_prenotazione ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Logica di business --------------------------- */
            printf("inserisci matricola: \n");
            gets(inp_1.matricola);

            out_1 = elimina_prenotazione_1(&inp_1, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                printf("Risultato ottenuto: %d\n", *out_1);
            }

        }
        /* FINE elimina_prenotazione =================================== */
        /* -------------------------------------------------- */
        /* visualizza_multiple ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            out_2 = visualizza_multiple_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if ((out_2 -> dimLista) < 0 ) {
                printf("Il dato richiesto non esiste sul server!\n");
            } else {
                for ( i = 0; i < out_2 -> dimLista ; i++ ){
                    printf("- %s\n", out_2 -> risultato[i].matricola);
                }
            }

        } 
        /* FINE visualizza_multiple =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi: 1 = elimina_prenotazione, 2 = visualizza_multiple\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}