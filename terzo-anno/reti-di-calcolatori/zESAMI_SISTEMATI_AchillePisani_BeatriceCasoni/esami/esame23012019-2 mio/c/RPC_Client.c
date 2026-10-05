/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

// BALLOTTI MATTIA 0001077835

#include "RPC_xFile.h"
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
    static InputAggiorna         inp_2;

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
    printf("Servizi:  1= visualizza_prenotazioni, 2= aggiorna_licenza\n");
    while (gets(servizio)) {

        printf("Richiesto servizio: %s\n", servizio);

        /* visualizza_prenotazioni ======================================== */
        if (strcmp(servizio, "1") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
            printf("Inserisci tipologia (\"auto\" | \"camper\"): ");
            gets(inp_1.tipo);

            out_1 = visualizza_prenotazioni_1(&inp_1, clnt); // Chiamata RPC

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if ((out_1 -> numPrenotazioni) < 0 ) {
                printf("Brand non esiste sul server!\n");
            } else {
                for ( i = 0; i < out_1 -> numPrenotazioni ; i++ ){
                    printf("%d) | Targa: %s | Patente: %s | IMG: %s | Tipo: %s |\n", 
                        i+1, out_1 -> prenotazioni[i].targa, out_1 -> prenotazioni[i].patente, out_1 -> prenotazioni[i].img, out_1 -> prenotazioni[i].tipo);
                }
            }

        }
        /* FINE visualizza_prenotazioni =================================== */
        /* -------------------------------------------------- */
        /* aggiorna_licenza ======================================== */
        else if (strcmp(servizio, "2") == 0) {

            /* Variabili ------------------------------------ */

            /* Logica di business --------------------------- */
			printf("Inserisci targa della patente da aggiornare: ");
            gets(inp_2.targa);

			printf("Inserisci nuova patente: ");
            gets(inp_2.patente);

            out_2 = aggiorna_licenza_1(&inp_2, clnt); // Chiamata RPC

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                printf("Risultato: %d\n", *out_2);
            }

        } 
        /* FINE aggiorna_licenza =================================== */
        else {
            printf("Servizio richiesto non supportato!\n");
        }

        printf("Servizi:  1= visualizza_prenotazioni, 2= aggiorna_licenza\n");
    } /* ricevuto eof */

    /* LOGICA DI BUSINESS ----------------------------------- */

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}