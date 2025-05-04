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
    int    *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static InputElimina      inp_1;
    static InputNoleggia      inp_2;

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
    printf("Servizi:  1 = elimina_sci, 2 = noleggia_sci\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* elimina_sci ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Logica di business --------------------------- */
            printf("inserisci id: \n");
            gets(inp_1.id);

            if ( strlen(inp_1.id) == 0 ){
                printf("Stringa vuota\n Inserisci id:\n");
                continue;
            }

            out_1 = elimina_sci_1(&inp_1, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                printf("Risultato ottenuto: %d\n", *out_1);
            }

        }
        /* FINE elimina_sci =================================== */
        /* -------------------------------------------------- */
        /* noleggia_sci ======================================== */
        else if (strcmp(servizio, "2") == 0) {
            // variabili da spostare
            char dataString[MAX_NAME_SIZE];
            char numString[MAX_NAME_SIZE];

            /* Logica di business --------------------------- */
            // INSERISCO ID
            printf("inserisci id: \n");
            gets(inp_2.id);
            
            if ( strlen(inp_2.id) == 0 ){
                printf("Stringa vuota\n Inserisci id:\n");
                continue;
            }
            
            // INSERISCO DATA
            printf("Inserisci data GG/MM/YYYY: \n");
            gets(dataString);

            // Controlli sulla data
            strcpy(inp_2.data, dataString ); 
            
            // INSERISCO GIORNI
            printf("Inserisci giorni: \n");
            gets(numString);
            
            // Controlli sui giorni
            int valido = 1;
            if (numString[0] == '\0') {
                printf("Stringa vuota!\n");
                valido = 0;
            } else {
                for (int i = 0; numString[i] != '\0'; i++) {
                    if (numString[i] <= '0' && numString[i] >= '9' ) {
                        valido = 0;
                        break;
                    }
                }
            }

            if (!valido) {
                printf("Errore, inserire un intero valido\n");
                continue;
            } else {
                inp_2.giorni = atoi(numString);
            }

            out_2 = noleggia_sci_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if ((*out_2) < 0 ) {
                printf("Il dato richiesto non esiste sul server!\n");
            } else {
                printf("Risultato ottenuto: %d\n", *out_2);
            }

        } 
        /* FINE noleggia_sci =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi: 1 = elimina_sci, 2 = noleggia_sci\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}