/*
/// Author: Nome Cognome
/// Matricola: 0000000000
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
    printf("Servizi:  1= noleggia_sci_, 2= elimina_sci\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* noleggia_sci_ ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("inserisci l id : \n");
            gets(inp_1.id);

            printf("inserisci giorno : \n");
            gets(inp_1.giorno);

            printf("inserisci mese : \n");
            gets(inp_1.mese);

            printf("inserisci anno : \n");
            gets(inp_1.anno);
            
            printf("inserisci durata : \n");
            gets(inp_1.giorniDurata);

            out_1 = noleggia_sci_1(&inp_1, clnt); // Chiamata RPC

            // if (out_1 == NULL) {
            //     clnt_perror(clnt, "È avvenuto un errore lato server");
            // } else 
           if (out_1 == NULL) {
                clnt_perror(clnt, "Errore lato server (noleggia_sci_)");
            } else {
                printf("Risultato: %d\n", *out_1);
            }

        }
        /* FINE noleggia_sci_ =================================== */
        /* -------------------------------------------------- */
        /* elimina_sci ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("inserisci id!\n");
            gets(inp_2.id);

            out_2 = elimina_sci_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "Errore lato server (elimina_sci)");
            } else {
                printf("Risultato: %d\n", *out_2);
            }

        } 
        /* FINE elimina_sci =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi:  1= noleggia_sci_, 2= elimina_sci\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}