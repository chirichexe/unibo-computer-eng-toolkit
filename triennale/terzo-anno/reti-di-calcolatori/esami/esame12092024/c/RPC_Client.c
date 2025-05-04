/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
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

int main(int argc, char *argv[]) {
    CLIENT         *clnt;
    int            *ris;
    int            *out_1;
    OutputSoglia   *out_2;
    char           car, ok[128];

    // The variables used for RPC must be NOT stored on the local stack,
    // otherwise they are inaccessible from the stubs. So, we must either
    //  (a) allocate them using malloc (e.g., strings), or
    //  (b) declare them static

    static Matricola    matricola;
    static int          soglia;

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

    /* ---- logica di business ---- */
    printf("Servizi:  1= Elimina, 2=Soglia\n");
    while (gets(ok)) {
        if ((strcmp(ok, "1") != 0) && (strcmp(ok, "2") != 0)) {
            printf("scelta non disponibile\n");
            printf("Servizi:  1= Elimina, 2=Soglia\n");
            continue;
        }

        printf("Richiesto servizio: %s\n", ok);

        // Servizio 1
        if (strcmp(ok, "1") == 0) {
            printf("inserisci il nome matricola: \n");
            gets(matricola.matricola);

            out_1 = elimina_prenotazione_1(&matricola, clnt);

            if (out_1 == NULL) {
                clnt_perror(clnt, "È avvenuto un errore lato server");
            } else if (*out_1 < 0) {
                printf("Matricola richiesta non esiste sul server!\n");
            } else {
                printf("Prenotazione eliminata\n");
            }

        }

        // Servizio 2
        else if (strcmp(ok, "2") == 0)
        {

            // controllo intero
            printf("inserisci la soglia: \n");
            while (scanf("%d", &soglia) != 1) {
                do {
                    car = getchar();
                    printf("%c ", car);
                } while (car != '\n');
                printf("Inserire int");
                continue;
            }
            gets(ok);

            out_2 = visualizza_voto_maggiore_soglia_1(&soglia, clnt);

            if (out_2 == NULL) {
                clnt_perror(clnt, "E' avvenuto un errore lato server");
            } else {
                for (int i = 0; i < out_2->numMatricole; i++)
                {
                    printf("\t-%s\n", out_2->matricole[i].matricola);
                }
                
            }
        } else {
            printf("Servizio non supportato!\n");
        }
        printf("Servizi:  1= Elimina, 2=Soglia\n");
    } // while

    clnt_destroy(clnt);
    printf("Esco dal client\n");
    return 0;
}