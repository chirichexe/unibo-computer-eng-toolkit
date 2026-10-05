/*
/// Author: Nome Cognome
/// Matricola: 0000000000
*/

#include "esame.h"
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
    int             *out_1;
    OutputLista     *out_2;

    // Input metodi RPC (variabili dichiarate statiche) 
    static InputConta   inputConta;
    static InputLista   inputLista;

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
    printf("Servizi:  1= elimina_occorrenze, 2= lista_file_caratteri\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* elimina_occorrenze ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("inserisci il nome del file: \n");
            gets(inputConta.fileName);

            // printf("inserisci linea: \n");
            // gets(inputConta.linea);

            out_1 = elimina_occorrenze_1(&inputConta, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if (*out_1 < 0) {
                printf("Directory richiesta non esiste sul server!\n");
            } else {
                printf("Risultato: %d\n", *out_1);
            }

        }
        /* FINE elimina_occorrenze =================================== */
        /* -------------------------------------------------- */
        /* lista_file_caratteri ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Variabili ------------------------------------ */
            char car;
            char numOccString[5];
            int valido;

            /* Logica di business --------------------------- */
            printf("inserisci il nome della directory: \n");
            gets(inputLista.dirName);

            printf("Inserisci Carattere: \n");
            inputLista.carattere = getchar();

            if (getchar() != '\n') {
                printf("Errore, inserire un solo carattere valido\n");
                while (getchar() != '\n');
                continue;
            }

            printf("inserisci il numOccorrenze: \n");
            get(numOccString);
            
            // Validazione intero
            valido = 1;
            if (numOccString[0] == '\0') {
                printf("Stringa vuota!\n");
                valido = 0;
            } else {
                for (int i = 0; numOccString[i] != '\0'; i++) {
                    if (numOccString[i] < '0' && numOccString[i] > '9' ) {
                        valido = 0;
                        break;
                    }
                }
            }

            if (!valido) {
                printf("Errore, inserire un intero valido\n");
                continue;
            }

            inputLista.numOccorrenze  = atoi(numOccString);
            out_2 = lista_file_caratteri_1(&inputLista, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else if ( (out_2 -> status) < 0 ){
                printf("Errore nella ricezione\n");
            }
            else {
                printf("Ricevuto:\n");
                for (int i = 0; i < out_2->numFiles; i++)
                {
                    printf("\t-%s\n", out_2->files[i].nome);
                }
            }

        } 
        /* FINE lista_file_caratteri =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi:  1= elimina_occorrenze, 2= lista_file_caratteri\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}