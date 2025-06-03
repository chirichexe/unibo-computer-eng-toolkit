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

//Definizione funzioni
int controlloArgomenti(int argc, char *argv[]);
void wait_child();

//Definzione variabili
#define PID_SIZE 2
int pid[PID_SIZE];

//Main
int main(int argc, char *argv[]) {
    // Controllo Argomenti
    if (controlloArgomenti(argc, argv) == 1)
        return 1;

    //Conversione a intero
    int N = atoi(argv[2]);

    for (int i = 0; i < PID_SIZE; i++){
        pid[i] = fork();
        if (pid[i] < 0){
            perror("Errore nella creazione dei figli!");
        } else if (pid[i] == 0){
            if (i == 0) {
                //Figlio P1
                printf("Sono il figlio P1: PID %d\n", getpid());
                exit(0);
            } else if (i == 1) {
                //Figlio P2
                printf("Sono il figlio P2: PID %d\n", getpid());
                exit(0);
            }
        } else if (pid[i] < 0) { // Eseguito dal padre in caso di errore
            perror("Fork error:");
            exit(1);
        }
    }

    //Padre P0
    printf("Sono il padre: PID %d\n", getpid());
    for (int i = 0; i < PID_SIZE; i++) {
        wait_child();
    }

    return 0;
}

void wait_child() {
    int pid_terminated, status;
    pid_terminated = wait(&status);
    if (pid_terminated < 0)    {
        fprintf(stderr, "P0: errore in wait. \n");
        exit(EXIT_FAILURE);
    }
    if (WIFEXITED(status)) {
        printf("P0: terminazione volontaria del figlio %d con stato %d\n", pid_terminated, WEXITSTATUS(status));
        if (WEXITSTATUS(status) == EXIT_FAILURE) {
            fprintf(stderr, "P0: errore nella terminazione del figlio pid_terminated\n");
            exit(EXIT_FAILURE);
        }
    }
    else if (WIFSIGNALED(status)) {
        fprintf(stderr, "P0: terminazione involontaria del figlio %d a causa del segnale %d\n", pid_terminated,WTERMSIG(status));
        exit(EXIT_FAILURE);
    }
}

int controlloArgomenti(int argc, char *argv[]) {
    printf("---Davide Chirichella: System call---\n---0001071414---\n\n");
    //Controllo argomenti
    if (argc != 3) {
        printf("L'interfaccia deve essere del tipo ./Fin N Fout\n");
        return 1;
    }
    
    // Controlla che il primo argomento sia un file esistente
    struct stat buffer;
    if (stat(argv[1], &buffer) != 0) {
        perror("Errore: Il file non esiste");
        return 1;
    }

    // Controlla che il secondo argomento sia un intero
    char *p = argv[2];
    while (*p) {
        if (!isdigit(*p)) {
            printf("Errore: Il secondo argomento deve essere un numero intero\n");
            return 1;
        }
        p++;
    }

    return 0;
}
