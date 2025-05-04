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
    int            *out_1;
    OutputSoglia   *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static Matricola    matricola;
    static int          soglia;

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

    /* Ricevo fino ad eof ----------------------------------- */    
    printf("Servizi:  1= SERVIZIO1, 2= SERVIZIO2\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* SERVIZIO1 ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("inserisci il nome matricola: \n");
            gets(matricola.matricola);

            out_1 = servizio1_1(&matricola, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if (*out_1 < 0) {
                printf("Matricola richiesta non esiste sul server!\n");
            } else {
                printf("Prenotazione eliminata\n");
            }

        }
        /* FINE SERVIZIO1 =================================== */
        /* -------------------------------------------------- */
        /* SERVIZIO2 ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Variabili ------------------------------------ */
            char car;

            /* Logica di business --------------------------- */
            printf("inserisci la soglia: \n");
            while (scanf("%d", &soglia) != 1) {
                do {
                    car = getchar();
                    printf("%c ", car);
                } while (car != '\n');
                printf("Inserire int");
                continue;
            }
            gets(servizio);

            out_2 = servizio2_1(&soglia, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                for (int i = 0; i < out_2->numMatricole; i++)
                {
                    printf("\t-%s\n", out_2->matricole[i].matricola);
                }
            }

        } 
        /* FINE SERVIZIO2 =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi:  1= SERVIZIO1, 2= SERVIZIO2\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}