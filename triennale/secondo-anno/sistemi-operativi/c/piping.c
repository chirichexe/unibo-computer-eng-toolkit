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
int fd[2];
int fd_in;
int fd_o;

//Main
int main(int argc, char *argv[]) {
    // Controllo Argomenti
    if (controlloArgomenti(argc, argv) == 1)
        return 1;

    //Conversione a intero
    int N = atoi(argv[2]);

    //Pipe
    if (pipe(fd) < 0) {
        perror("Errore nella pipe");
        exit(1);
    }

    for (int i = 0; i < PID_SIZE; i++){
        pid[i] = fork();
        if (pid[i] < 0){
        } else if (pid[i] == 0){
            if (i == 0) {
                //Figlio P1
                printf("Sono il figlio P1: PID %d\n", getpid());

                //Dichiaro variabili e chiudo la lettura
                char charLetto;
                close(fd[0]);

                //Apro il file da leggere
                fd_in = open(argv[1], O_RDONLY);
                if (fd_in < 0) {
                    perror("Errore nell'apertura del file");
                    exit(1);
                }

                while (read(fd_in, &charLetto, 1) > 0){         //Invio tutto ciò che leggo dal file nella pipe
                    int offset = lseek(fd_in, 0, SEEK_CUR);     //Offset tiene traccia dell'indice a cui sono arrivato
                    if (offset % N == 0 && charLetto != '\n'){  //Se offset è divisibile per N lo invio
                        write(fd[1], &charLetto, 1);            //Invio all'altro capo della pipe  
                    }
                }

                //Chiudo file e pipe
                close(fd_in);
                close(fd[1]);

                exit(0);
            } else if (i == 1) {
                //Figlio P2
                printf("Sono il figlio P2: PID %d\n", getpid());
            }
        } else if (pid[i] < 0) { // Eseguito dal padre in caso di errore
            perror("Fork error:");
            exit(1);
        }
    }
    //Padre P0

    //Dichiaro variabili e chiudo la scrittura
    char charInviato;
    close(fd[1]);

    //Apertura file in cui scrivere
    fd_o = open(argv[3], O_WRONLY);
    if (fd_o < 0) {
        perror("Errore nell'apertura del file");
            exit(1);
        }

    //Scrivo sul file il contenuto ricevuto dall'altro capo della pipe
    printf("\nInizio a scrivere sul file...");
    while (read(fd[0], &charInviato, 1) > 0){       //Ricevo caratteri dall'altro capo della pipe
        write(fd_o, &charInviato, sizeof(char));    //Li scrivo
    }
    printf("\nFine...\n");
    
    //Chiudo pipe e file di scrittura
    close(fd_o);
    close(fd[0]);

    //Attesa chiusura figli
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
    if (argc != 4) {
        printf("L'interfaccia deve essere del tipo ./esame Fin N Fout\n");
        return 1;
    }
}
