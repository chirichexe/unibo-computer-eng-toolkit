#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include <ctype.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <signal.h>
#include <fcntl.h>
#include <unistd.h>

// Variabili globali ed eventuali strutture ------------------
#define MAX_SIZE 30

typedef struct {
    int id;
    int var;
} mioTipo;

int PID;
int pid[MAX_SIZE];
// -----------------------------------------------------------

// Funzioni default ------------------------------------------

int randomize(int lim) {
    //Da inizializzare nel main con: srand(time(NULL));
    return rand() % lim;
}

int controlloArgomenti(int argc, char *argv[]) {
    printf("---Davide Chirichella: System call---\n---0001071414---\n\n");
    //Controllo argomenti
    if (argc != 3) {
        printf("L'interfaccia deve essere del tipo ./X Y\n");
        return 1;
    }
}
// -----------------------------------------------------------
//  Main
// -----------------------------------------------------------

int main(int argc, char *argv[]) {
    // Controllo Argomenti
    if (controlloArgomenti(argc, argv) == 1)
        return 1;

    //Conversione a intero
    int S = atoi(argv[1]);

    PID = fork();
    //Ricorda: dopo la fork, se PID == 0, è il figlio, se > 0 è il padre

    if (PID > 0) {
        // PADRE P0
        printf("Padre (PID %d): creato il figlio P1 con pid: %d con successo\n", getpid(), PID);
        
        // Attendi la terminazione di P1
        wait(NULL);
        
        printf("Padre (PID %d): figlio P1 ha terminato\n", getpid());
        exit(0);

    } else if (PID == 0) {
        // FIGLIO P1
        printf("Figlio (PID=%d): inizio creazione dei figli\n", getpid());
        
        for (int i = 0; i < 5; i++) { // creazione nipoti
            pid[i] = fork();
            if (pid[i] == 0) { // Eseguito dai nipoti
                printf("Nipote %d (PID %d): non creerò ulteriori figli\n", i, getpid());
                exit(0);
            } else if (pid[i] < 0) { // Eseguito dal padre in caso di errore
                perror("Fork error:");
                exit(1);
            }
        }

        printf("Figlio (PID=%d): creati tutti i figli con successo\n", getpid());
        exit(0);

    } else {
        perror("Fork error:");
        exit(1);
    }
}
