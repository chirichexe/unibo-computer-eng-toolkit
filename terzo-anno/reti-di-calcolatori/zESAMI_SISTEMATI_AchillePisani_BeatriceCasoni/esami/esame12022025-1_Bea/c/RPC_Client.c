/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

#include "files.h"
#include <rpc/rpc.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    CLIENT         *clnt;
    int            *ris;
    OutputElimina  *out_1;
    OutputLista    *out_2;
    char           car, ok[128];

    // The variables used for RPC must be NOT stored on the local stack,
    // otherwise they are inaccessible from the stubs. So, we must either
    //  (a) allocate them using malloc (e.g., strings), or
    //  (b) declare them static

    static InputElimina  inputElimina;
    static InputLista    inputLista;

    // Controllo argomenti
    if (argc < 2) {
        printf("Uso: %s <indirizzo server>\n", argv[0]);
        exit(1);
    }

    // creazione stub
    clnt = clnt_create(argv[1], ESAME_PROG, ESAME_VERS, "tcp");
    if (clnt == NULL) {
        clnt_pcreateerror(argv[1]);
        exit(1);
    }

    /* ---- logica di busines ---- */
    printf("Servizi:  1= elimina parola, 2=lista NOMIFILE_SOGLIA\n");
    while (gets(ok)) {
        if ((strcmp(ok, "1") != 0) && (strcmp(ok, "2") != 0)) {
            printf("scelta non disponibile\n");
            printf("Servizi:  1= elimina parola, 2=lista NOMIFILE_SOGLIA\n");
            continue;
        }

        printf("Richiesto servizio: %s\n", ok);

        // Servizio 1
        if (strcmp(ok, "1") == 0) {
            printf("inserisci il nome file: \n");
            gets(inputElimina.fileName);

            printf("Inserisci la parola da eliminare:\n");
            gets(inputElimina.parolaUtente);


            out_1 = elimina_parola_1(&inputElimina, clnt);

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if (out_1->numEliminati == -1) {
                printf("Il file richiesto non esiste sul server!\n");
            } else {
                printf("Ho eliminato %d parole corrispondeni a quelle dell utente\n", out_1->numEliminati);
            }

        }

        // Servizio 2
        else if (strcmp(ok, "2") == 0)
        {
            // inserimento stringa
            printf("inserisci il nome directory: \n");
            gets(inputLista.dirName);

            // controllo intero
            printf("inserisci la soglia: \n");
            while (scanf("%d", &inputLista.soglia) != 1) {
                do {
                    car = getchar();
                    printf("%c ", car);
                } while (car != '\n');
                printf("Inserire int");
                continue;
            }
            gets(ok);

            // inserimento carattere
            // while (1) {
            //     printf("inserisci Il carattere da controllare: \n");
            //     gets(ok);
                
            //     if (strlen(ok) == 1) { // deve essere solo uno
            //         inputLista.carattere = ok[0];
            //         break;
            //     } else {
            //         printf("Errore: inserire esattamente un solo carattere.\n");
            //     }
            // }

            out_2 = lista_nomifile_soglia_1(&inputLista, clnt);

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else if (out_2->status < 0) {
                printf("Il direttorio richiesto non esiste sul server o c'è stato un errore alla chiusura file!\n");
            } else {
                printf("Ho contato %d file:\n", out_2->numFile);
                for (int j = 0; j < out_2->numFile; j++) {
                    printf("%s\n", out_2->nomiFile[j].name);
                }
            }
        }
        else
        {
            printf("Servizio non supportato!\n");
        }
        printf("Servizi:  1= elimina parola, 2=lista NOMIFILE_SOGLIA\n");
    } // while

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}