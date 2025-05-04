/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/select.h>

#define DIM_BUFF 1024
#define MAX_NAME_SIZE 256
#define MAX_LIST_SIZE 7

#define max(a, b) ((a) > (b) ? (a) : (b))

/********************************************************/
#define N 12

/*
if (inizializzato == 0) {
    inizializza();
}
*/

/* STRUTTURA DATI INTERNA PRIVATA DEL SERVER ========== */
typedef struct {

    char id[MAX_NAME_SIZE];
    char data[10];
    int giorni;
    char modello[MAX_NAME_SIZE];
    int costoGiorni;
    char foto[MAX_NAME_SIZE];

} Riga;

static Riga t[N];
static int  inizializzato = 0;

/* Inizializza lo stato del server -------------------- */
void inizializza() {
    int i;
    if (inizializzato == 1) {
        return;
    }

    // Inizializzato tutto come vuoto
    for (i = 0; i < N; i++) {
        strcpy(t[i].id, "L");
        strcpy(t[i].data, "-1/-1/-1");
        t[i].giorni, -1;
        strcpy(t[i].modello, "-1");
        t[i].costoGiorni = -1;
        strcpy(t[i].foto, "L");
    }

    // Valori inizializzati per i test
    strcpy(t[0].id, "id1");
    strcpy(t[0].data, "10/11/2004");
    t[0].giorni= 3;
    strcpy(t[0].modello, "Sci1");
    t[0].costoGiorni = 4;
    strcpy(t[0].foto, "f1");

    strcpy(t[1].id, "id2");
    strcpy(t[1].data, "L");
    t[1].giorni = -1;
    strcpy(t[1].modello, "Sci2");
    t[1].costoGiorni = 3;
    strcpy(t[1].foto, "f2");

    strcpy(t[2].id, "id3");
    strcpy(t[2].data, "20/20/2023");
    t[2].giorni =31;
    strcpy(t[2].modello, "Sci1");
    t[2].costoGiorni = 3;
    strcpy(t[2].foto, "f2");

    inizializzato = 1;
    printf("Terminata inizializzazione struttura dati!\n");
}

/********************************************************/
void gestore(int signo)
{
    int stato;
    printf("esecuzione gestore di SIGCHLD\n");
    wait(&stato);
}
/********************************************************/

int main(int argc, char **argv)
{
    /* --- variabili connessione --- */
    int listenfd, connfd, udpfd, nready, maxfdp1;
    const int on = 1;
    fd_set rset;
    int len, nread, num, port;
    struct sockaddr_in cliaddr, servaddr;

    /* CONTROLLO ARGOMENTI ---------------------------------- */
    if (argc != 2)
    {
        printf("Error: %s port\n", argv[0]);
        exit(1);
    }

    nread = 0;
    while (argv[1][nread] != '\0')
    {
        if ((argv[1][nread] < '0') || (argv[1][nread] > '9'))
        {
            printf("Terzo argomento non intero\n");
            exit(2);
        }
        nread++;
    }
    port = atoi(argv[1]);
    if (port < 1024 || port > 65535)
    {
        printf("Porta scorretta...");
        exit(2);
    }

    /* INIZIALIZZAZIONE INDIRIZZO SERVER E BIND ---------------------------- */
    memset((char *)&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = INADDR_ANY;
    servaddr.sin_port = htons(port);
    printf("Server avviato\n");

    /* CREAZIONE SOCKET TCP ------------------------------------------------ */
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd < 0)
    {
        perror("apertura socket TCP ");
        exit(1);
    }
    printf("Creata la socket TCP d'ascolto, fd=%d\n", listenfd);

    if (setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0)
    {
        perror("set opzioni socket TCP");
        exit(2);
    }
    printf("Set opzioni socket TCP ok\n");

    if (bind(listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0)
    {
        perror("bind socket TCP");
        exit(3);
    }
    printf("Bind socket TCP ok\n");

    if (listen(listenfd, 5) < 0)
    {
        perror("listen");
        exit(4);
    }
    printf("Listen ok\n");

    /* CREAZIONE SOCKET UDP ------------------------------------------------ */
    udpfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (udpfd < 0)
    {
        perror("apertura socket UDP");
        exit(5);
    }
    printf("Creata la socket UDP, fd=%d\n", udpfd);

    if (setsockopt(udpfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0)
    {
        perror("set opzioni socket UDP");
        exit(6);
    }
    printf("Set opzioni socket UDP ok\n");

    if (bind(udpfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0)
    {
        perror("bind socket UDP");
        exit(7);
    }
    printf("Bind socket UDP ok\n");

    /* AGGANCIO GESTORE PER EVITARE FIGLI ZOMBIE -------------------------------- */
    signal(SIGCHLD, gestore);

    /* PULIZIA E SETTAGGIO MASCHERA DEI FILE DESCRIPTOR ------------------------- */
    FD_ZERO(&rset);
    maxfdp1 = max(listenfd, udpfd) + 1;

    /* CICLO DI RICEZIONE EVENTI DALLA SELECT ----------------------------------- */
    for (;;)
    {

        FD_SET(listenfd, &rset); // Ascolto della listenfd
        FD_SET(udpfd, &rset);    // Ascolto della udfpd

        if ((nready = select(maxfdp1, &rset, NULL, NULL, NULL)) < 0)
        {
            if (errno == EINTR)
                continue;
            else {
                perror("select");
                exit(8);
            }
        }

        /* GESTIONE RICHIESTE DI COMANDI REMOTI ------------------------------------- */
        
        /* Servizio TCP ------------------------------------------------------------- */

        if (FD_ISSET(listenfd, &rset)) {

            if (inizializzato == 0) {
                inizializza();
            }

            printf("Ricevuta richiesta di esecuzione comando TCP\n");
            len = sizeof(struct sockaddr_in);
            if ((connfd = accept(listenfd, (struct sockaddr *)&cliaddr, &len)) < 0) {
                if (errno == EINTR) continue;
                else {
                    perror("accept");
                    exit(9);
                }
            }
            
            int pid = fork(); // per gestione multiprocesso

            if (pid > 0) {
                close(connfd);
                printf("Processo padre: gestore assegnato al figlio con PID %d\n", pid);
            } else if (pid == 0) {
                close(listenfd);
                printf("Creato processo figlio con PID %d per gestire il cliente\n", getpid());

                /* Variabili ------------------------------------------------------------ */
                char input[MAX_NAME_SIZE];
                int result = 0;
                char buffer[DIM_BUFF];
                
                /* Logica di business --------------------------------------------------- */
                while (1) {
                    
                    memset(input, 0, MAX_NAME_SIZE);
                    if (read(connfd, input, sizeof(input)) < 0) {
                        perror("read");
                        close(connfd);
                        exit(1);
                    }
                    printf("Input ricevuto dal client %s\n", input);

                    for (int i = 0; i < N; i++) {
                        printf("%s - %s\n", t[i].modello, input);
                        if ( strcmp(t[i].modello, input) == 0 ) {

                            // Invio nome -----------------------------------------------
                            printf("Servizio TCP: Invio id: %s\n", t[i].id);
                            if (write(connfd, t[i].id, MAX_NAME_SIZE) < 0) {
                                perror("write");
                                exit(1);
                            }
                        }
                    }
                    printf("Invio FINE\n...");
                    strcpy(buffer, "FINE");
                    if (write(connfd, buffer, DIM_BUFF) < 0) {
                        perror("write");
                        exit(1);
                    }
                    memset(input, 0, MAX_NAME_SIZE);
                }

                /* Fine logica di business ---------------------------------------------- */
                
            } else {
                perror("fork");
                exit(1);
            }
            close(connfd);
        }

        /* Fine servizio TCP -------------------------------------------------------- */
        // ========================================================================== //
        /* Servizio UDP ------------------------------------------------------------- */

        if (FD_ISSET(udpfd, &rset)) {
            if (inizializzato == 0) {
                inizializza();
            }
            printf("Ricevuta richiesta UDP\n");

            /* Variabili ------------------------------------------------------------ */
            len = sizeof(cliaddr);
            char input[MAX_NAME_SIZE];
            int risultato = -1;

            /* Logica di business --------------------------------------------------- */

            while(1){

                memset(input, 0, sizeof(input));
                
                if (recvfrom(udpfd, input, sizeof(input), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                    perror("recvfrom");
                    continue;
                }

                printf("Servizio UDP: Id richiesto: %s\n", input);

                // Stampa dell'intestazione
                printf("ID\tDATA\t\tGIORNI\tMODELLO\t\tCOSTO\tFOTO\n");
                printf("--------------------------------------------------------\n");

                // Stampa dei record
                for (int i = 0; i < N; i++) {
                    printf("%s\t%s\t%d\t%s\t\t%d\t%s\n",
                        t[i].id,
                        t[i].data,
                        t[i].giorni,
                        t[i].modello,
                        t[i].costoGiorni,
                        t[i].foto);
                }

                for (int i = 0; i < N; i++) {
                    if ( strcmp(t[i].id, input) == 0 && t[i].giorni > 0) {
                        risultato = t[i].costoGiorni * t[i].giorni;
                        break;
                    }
                }
                
                if (sendto(udpfd, &risultato, sizeof(risultato), 0, (struct sockaddr *)&cliaddr, len) < 0) {
                    perror("sendto");
                    continue;
                }

            }


            /* Fine logica di business ----------------------------------------------- */
        }

        /* Fine servizio UDP -------------------------------------------------------- */

    } /* fine ciclo for della select */
    exit(0);
}