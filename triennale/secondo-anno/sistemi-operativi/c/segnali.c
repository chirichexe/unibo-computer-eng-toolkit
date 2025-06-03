#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <math.h>
#include <time.h>

int T, pid1, pid2;
int figli_terminati=0;

/*
La struttura del segnale deve essere:
DICHIARAZIONE -> signal(SIGUSRN,pidobb_handler);
INVIO -> kill(pid_obiettivo, SIGUSRN)
RICEZIONE dal processo obiettivo -> pidobb_handler(int sig){
    if (sig == SIGUSRN){
        fai cose...
        exit(0)
    }
}

//ESEMPIO NOTEVOLE: ALARM

//Dichiaro l'alarm
alarm(S);
signal(SIGALRM, alarm_handler);

//Dichiaro l'handler
void alarm_handler(int signo){
    printf("\nTimeout scaduto!\n");
    exit(0);
}


*/


void P2_handler(int signo){
    if (signo==SIGUSR2){
        printf("P2 (PID=%d): ricevuto SIGUSR2. Lancio il comando <date>\n", getpid());
        execlp("date","date", (char *)0);
        perror("P2: Exec fallita.");
        exit(EXIT_FAILURE);
    }else{
        perror("P2: Ricezione di segnale imprevisto");
        exit(EXIT_FAILURE);
    }
}

void P0_handler(int signo){
    if (signo==SIGUSR1){
        printf("P0 (PID=%d): ricevuto SIGUSR1. Finito!\n", getpid());
        kill(pid1,SIGKILL);
        kill(pid2,SIGKILL);
        exit(0);
    }else if (signo==SIGUSR2){
        printf("P0 (PID=%d): ricevuto SIGUSR2. Inoltro il segnale a P2!\n", getpid());
        kill(pid2,SIGUSR2);
        exit(0);
    }else if (signo==SIGCHLD){
        figli_terminati++;
        printf("P0 (PID=%d): ricevuto SIGCHLD - figli terminati = %d.\n",getpid(), figli_terminati);
        if (figli_terminati==2){
            printf("P0 (PID=%d): Tutti i figli sono terminati!\n",getpid());    
            exit(0);
        }
    }else{
        perror("P0: Ricezione di segnale imprevisto");
        exit(1);
    }    
}


int main(int argc, char* argv[]){
    //impostazione trattamento segnali (verrà ereditata dai figli)
    signal(SIGUSR1, P0_handler);
    signal(SIGUSR2, P0_handler);
    signal(SIGCHLD, P0_handler);

     // creazione P1
    pid1 = fork();
    if (pid1==0){ //P1
        //reimposto l'azione di default per i segnali che il figlio non deve gestire
        signal(SIGUSR1, SIG_DFL);
        signal(SIGUSR2, SIG_DFL);
        signal(SIGCHLD, SIG_DFL);
        
        sleep(3);
        
        srand(time(NULL));
        int dado=rand()%2; // compreso tra 0 e 1

        if (dado==0){
            printf("P1 (PID=%d): La moneta ha dato esito %d. Invio SIGUSR1 a P0\n",getpid(),dado);
            kill(getppid(), SIGUSR1);
        }else{
            printf("P1 (PID=%d): La moneta ha dato esito %d. Invio SIGUSR2 a P0\n",getpid(),dado);
            kill(getppid(), SIGUSR2);
        }
        exit(0);

    }else if (pid1>0){ 
        // creazione P2
        pid2 = fork();
        if (pid2==0){ //P2
            //P2:
            signal(SIGUSR2, P2_handler);
            //reimposto l'azione di default per i segnali che il figlio non deve gestire
            signal(SIGUSR1, SIG_DFL);
            signal(SIGALRM, SIG_DFL); 
            signal(SIGCHLD, SIG_DFL);
            
            pause(); //P2 attende indefinitamente l'arrivo di un segnale
            exit(0);

        }else if (pid2>0){ 
            //P0:
            for(int i=0;;i++){
                sleep(1);
                printf("P0 (PID=%d): attendo un segnale da %d secondi\n", getpid(), i);
            }
        }else{
            fprintf(stderr, "Errore nella seconda fork()\n");
            exit(1);
        }

    }else{
        fprintf(stderr, "Errore nella prima fork()\n");
        exit(1);
    }
}
