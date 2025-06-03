#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

/*
Ridirezione output su lato scrittura pipe:
    RECEIVER:
        close(fd[1]);
        char charInviato;

        //Scrivo sul standard output il contenuto ricevuto dall'altro capo della pipe
        while (read(fd[0], &charInviato, sizeof(char)) > 0){ //Ricezione caratteri
            printf("%c", charInviato);
        }
                
        //Chiudo pipe
        close(fd[0]);
        exit(0);

        //Se avessi voluto bufferizzare: char buffer[MAXS];
        //...leggo char dalla pipe...
        //        buffer[cont] = charInviato
        //        cont++;
        //...fine lettura...
        //buffer[cont] = '\0';

    SENDER:

        close(fd[0]);
        close(1);
        dup(fd[1]);
        execlp("cut", "cut", "-d", " ", "-f", argv[3], argv[1], (char*)0);
        perror("execlp failed");
        close(fd[1]);
        exit(0);

    VA FATTA ANCHE LA CLOSE DI FD0 FD1 DAL PADRE!!
*/

#define NP 8 // al massimo 8 figli
#define MAXS 256

void figlio(int fd_out, char filein[], char word[]);
void wait_child();

int pp[2]; // pipe per la comunicazione figli ->padre

int main(int argc, char **argv){
    int pid[NP];
    int i,N; // numero di figli
    char parola[MAXS],buffer[MAXS];
    int tot_occ=0;

    // controllo argomenti:
    if (argc < 3) { // almeno 2 argomenti F1.. FN parola
        printf("Sintassi: %s F1.. FN parola\n", argv[0]);
        exit(-1);
    }

    N = argc - 2; // N è il numero di file -> numero dei figli
    if (N > NP) {
        printf("Troppi file!\n");
        exit(-2);
    }

    // Apertura pipe pp:
    if (pipe(pp) < 0) {
        perror("Apertura pipe fallita");
        exit(-3);
    }

    /* creazione figli: */
    for (i = 0; i < N; i++) {
        if ((pid[i] = fork()) < 0) {
            perror("Errore fork");
            exit(-3);
        } else if (pid[i] == 0) { // figlio i
            close(pp[0]); // chiude il lato di lettura di pp
            figlio(pp[1], argv[i + 1], argv[argc - 1]);
        }
    }

    // Padre:
    close(pp[1]); // chiude il lato di scrittura di pp
    for (i = 0; i < N; i++) {
        int letto, cont, fine, nread;
        cont = 0;
        fine = 0;
        while (!fine) {
            nread = read(pp[0], &buffer[cont], 1); // leggo il prossimo char dalla pipe
            if ((nread == 1) && (buffer[cont] != '\n')) { // ho letto un char significativo
                cont++;
            } else {
                fine = 1;
            }
        }
        buffer[cont] = '\0';
        letto = atoi(buffer);
        tot_occ += letto;
    }

    sprintf(buffer, "%d\n", tot_occ); //converte in stringa il risultato
    write(1, buffer, strlen(buffer)); // stampa il risultato

    // attesa figli:
    for (i = 0; i < N; i++) {
        wait_child();
    }
    close(pp[0]); // chiude il lato di lettura la pipe
    exit(0);
}

void figlio(int fd_out, char filein[], char word[]) {
    // ridirezione output su lato scrittura pipe:
    close(1);
    dup(fd_out);
    close(fd_out);
    // esecuzione grep:
    execl("/bin/grep", "grep", "-c", word, filein, (char *)0);
    perror("Execl fallita");
    exit(-1);
}

void wait_child() {
    int pid_terminated, status;
    pid_terminated = wait(&status);
    if (WIFEXITED(status))
        printf("PADRE: terminazione volontaria del figlio %d con stato %d\n", pid_terminated, WEXITSTATUS(status));
    else if (WIFSIGNALED(status))
        printf("PADRE: terminazione involontaria del figlio %d a causa del segnale %d\n", pid_terminated, WTERMSIG(status));
}
