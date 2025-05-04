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

#define DIM_BUFF 100
#define MAX_COMMAND_SIZE 256
#define MAX_OUTPUT_SIZE 4096
#define MAX_NAME_SIZE 256
#define max(a, b) ((a) > (b) ? (a) : (b))

#define N 12 // Numero candidati

/*STATO INTERNO PRIVATO DEL SERVER*/
typedef struct {
    char targa[MAX_NAME_SIZE];
    char patente[6];
    char tipo[MAX_NAME_SIZE];
    char dirFoto[MAX_NAME_SIZE];
} Riga;

// variabili globali private (static)
static Riga t[N];
static int  inizializzato = 0;

/* Inizializza lo stato del server */
void inizializza() {
    int i;
    if (inizializzato == 1) {
        return;
    }

    // Tutto vuoto
    for (i = 0; i < N; i++) {
        strcpy(t[i].targa, "L");
        strcpy(t[i].patente, "L");
        strcpy(t[i].tipo, "L");
        strcpy(t[i].dirFoto, "L");
    }

    // Inizializziamo qualche valore per i test
    strcpy(t[0].targa, "TARGA1");
    strcpy(t[0].patente, "PAT01");
    strcpy(t[0].tipo, "auto");
    strcpy(t[0].dirFoto, "TARGA1_img/");

    strcpy(t[1].targa, "TARGA2");
    strcpy(t[1].patente, "PAT02");
    strcpy(t[1].tipo, "camper");
    strcpy(t[1].dirFoto, "TARGA2_img/");

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
    int listenfd, connfd, udpfd, nready, maxfdp1;
    const int on = 1;
    char buff[DIM_BUFF];
    fd_set rset;
    int len, nread, port;
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

        FD_SET(listenfd, &rset); // Voglio ascoltare la listenfd
        FD_SET(udpfd, &rset);    // Voglio ascoltare la udfpd

        if ((nready = select(maxfdp1, &rset, NULL, NULL, NULL)) < 0)
        {
            if (errno == EINTR)
                continue;
            else
            {
                perror("select");
                exit(8);
            }
        }

        /* GESTIONE RICHIESTE DI COMANDI REMOTI ------------------------------------- */
        
        /* Servizio 1 ---------------------------------------------------------*/
        // GESTIONE TCP
        if (FD_ISSET(listenfd, &rset)) {
            printf("Ricevuta richiesta di esecuzione comando TCP\n");
            len = sizeof(struct sockaddr_in);
            if ((connfd = accept(listenfd, (struct sockaddr *)&cliaddr, &len)) < 0) {
                if (errno == EINTR) 
                    continue;
                else {
                    perror("accept");
                    exit(9);
                }
            }

            // GESTIONE CLIENTE CON FORK
            int pid = fork();
            if (pid < 0) {
                perror("fork");
                exit(1);
            } else if (pid == 0) {
                
                // === INIZIALIZZA STRUTTURE DATI ===========================================
                if (inizializzato == 0) {
                    inizializza();
                }

                close(listenfd);
                printf("Creato processo figlio con PID %d per gestire il cliente\n", getpid());

                // variabili
                char dirname[DIM_BUFF];
                char targa[DIM_BUFF];

                // === LOGICA DI BUSINESS ====================================================

                while (1) {
                    // leggo nome targa e costruisco la directory
                    if (read(connfd, targa, sizeof(targa)) <= 0) {
                        perror("read");
                        close(connfd);
                        exit(1);
                    }
                    printf("Ricevuto nome targa: %s\n", targa);
                    snprintf(dirname, sizeof(dirname), "%s_img/", targa);

                    // === INVIO DIRECTORY ===================================================

                    DIR *dir = opendir(dirname);
                    if (dir == NULL) {
                        perror("Errore durante l'apertura della directory");
                        char response = 'a';
                        write(connfd, &response, 1);
                        exit(1);
                    }

                    char response = 'p';
                    write(connfd, &response, 1);

                    struct dirent *entry;
                    char file_name[DIM_BUFF];
                    char file_path[DIM_BUFF * 2];

                    while ((entry = readdir(dir)) != NULL) {
                        if (entry->d_name[0] == '.') continue;

                        memset(file_name, 0, DIM_BUFF);
                        printf("INVIO NOME FILE\n");
                        strncpy(file_name, entry->d_name, DIM_BUFF - 1);
                        if (write(connfd, file_name, DIM_BUFF) < 0) {
                            perror("Errore durante l'invio del nome del file");
                            closedir(dir);
                            exit(1);
                        }

                        snprintf(file_path, sizeof(file_path), "%s/%s", dirname, entry->d_name);
                        int fd = open(file_path, O_RDONLY);
                        if (fd < 0) {
                            perror("Errore durante l'apertura del file");
                            closedir(dir);
                            exit(1);
                        }

                        int file_size = lseek(fd, 0, SEEK_END);
                        lseek(fd, 0, SEEK_SET);

                        if (write(connfd, &file_size, sizeof(int)) < 0) {
                            perror("Errore durante l'invio della dimensione del file");
                            close(fd);
                            closedir(dir);
                            exit(1);
                        }

                        char buffer[DIM_BUFF];
                        int bytes_read;

                        while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                            if (write(connfd, buffer, bytes_read) < 0) {
                                perror("Errore durante l'invio del contenuto del file");
                                close(fd);
                                closedir(dir);
                                exit(1);
                            }
                        }

                        close(fd);
                    }

                    strcpy(file_name, "FINE");
                    write(connfd, file_name, DIM_BUFF);
                    closedir(dir);

                    // === FINE INVIO DIRECTORY ==============================================


                }

                // === FINE LOGICA DI BUSINESS ================================================

            } else {
                close(connfd);
                printf("Processo padre: gestore assegnato al figlio con PID %d\n", pid);
            }
            // FINE GESTIONE CLIENTE CON FORK
            
        }

        /* Servizio 2 ---------------------------------------------------------*/
        // GESTIONE UDP
        if (FD_ISSET(udpfd, &rset)) {
            printf("Ricevuta richiesta UDP\n");

            // variabili
            len = sizeof(cliaddr); //
            char numTarga[DIM_BUFF], numPatente[DIM_BUFF];
            int risultato = -1;

            // ricezione parametri in ingresso
            if (recvfrom(udpfd, numTarga, sizeof(numTarga), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                perror("recvfrom");
                continue;
            }
            printf("Servizio UDP: num targa ricevuto: %s\n", numTarga);

            if (recvfrom(udpfd, numPatente, sizeof(numPatente), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                perror("recvfrom");
                continue;
            }
            printf("Servizio UDP: num patente ricevuto: %s\n", numPatente);

            if (inizializzato == 0) {
                inizializza();
            }

            // === LOGICA DI BUSINESS ================================================ //
            for (int i = 0; i < N; i++) {
                if ( strcmp(t[i].targa,  numTarga) == 0 ){
                    strcpy(t[i].patente, numPatente);
                    risultato = 0;
                    break;
                }
            }
            // === FINE LOGICA DI BUSINESS =========================================== //

            // invia risultato
            printf("Invio risultato: %d\n", risultato);
            if (sendto(udpfd, &risultato, sizeof(risultato), 0, (struct sockaddr *)&cliaddr, len) < 0) {
                perror("scrittura socket");
                exit(0);
            }

        } /* fine gestione richieste UDP */

    } /* ciclo for della select */
    /* NEVER ARRIVES HERE */
    exit(0);
}
