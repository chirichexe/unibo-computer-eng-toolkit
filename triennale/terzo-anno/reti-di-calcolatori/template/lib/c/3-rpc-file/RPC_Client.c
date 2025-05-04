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
    OutputM2    *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static InputM1      inp_1;
    static InputM2      inp_2;

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
    printf("Servizi:  1 = SERVIZIO1, 2 = SERVIZIO2\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* SERVIZIO1 ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Logica di business --------------------------- */
            printf("inserisci elemento1: \n");
            gets(inp_1.elemento1);

            out_1 = servizio1_1(&inp_1, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                printf("Risultato ottenuto: %d\n", *out_1);
            }

        }
        /* FINE SERVIZIO1 =================================== */
        /* -------------------------------------------------- */
        /* SERVIZIO2 ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Logica di business --------------------------- */
            printf("inserisci elemento2: \n");

            gets(inp_2.elemento2);

            out_2 = servizio2_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if ((out_2 -> dimLista) < 0 ) {
                printf("Il dato richiesto non esiste sul server!\n");
            } else {
                for ( i = 0; i < out_2 -> dimLista ; i++ ){
                    printf("- %s\n", out_2 -> elementi[i].filename );
                }
            }

        } 
        /* FINE SERVIZIO2 =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi: 1 = SERVIZIO1, 2 = SERVIZIO2\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}