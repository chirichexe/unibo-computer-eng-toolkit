/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
/// Traccia: NUMTRACCIA
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
#define max(a, b) ((a) > (b) ? (a) : (b))

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
    char buff[DIM_BUFF], dirName[MAX_COMMAND_SIZE];
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

                close(listenfd);
                printf("Creato processo figlio con PID %d per gestire il cliente\n", getpid());
                while (1) {
                    if (read(connfd, dirName, sizeof(dirName)) <= 0) {
                        perror("read");
                        close(connfd);
                        exit(1);
                    }
                    // --- invio directory ---                      SNIPPET
                    DIR *dir = opendir(dirName);
                    if (dir == NULL) {
                        printf("Directory %s non presente\n", dirName);
                        write(connfd, "-\n", 2);
                    } else {
                        printf("Ricevuto nome directory: %s\n", dirName);
                        write(connfd, buff, strlen(buff));

                        int file_size;
                        struct dirent *entry;
                        char file_name[DIM_BUFF];

                        // --- scorre la directory ---
                        while ((entry = readdir(dir)) != NULL) {
                            if (entry->d_name[0] == '.') continue; // solo file regolari

                            // scrive il nome del file
                            memset(file_name, 0, DIM_BUFF);
                            strncpy(file_name, entry->d_name, DIM_BUFF - 1);
                            printf("Invio file: %s\n", file_name);
                            if (write(connfd, file_name, DIM_BUFF) < 0) {
                                perror("write");
                                //ERRORE
                            }

                            // costruisce percorso completo
                            char filePath[DIM_BUFF * 2];
                            memset(filePath, 0, sizeof(filePath));
                            
                            strcat(filePath, dirName);
                            strcat(filePath, "/");
                            strcat(filePath, entry->d_name);

                            // apre il file in sola lettura
                            int fd = open(filePath, O_RDONLY);
                            if (fd < 0) {
                                perror("Client:mput: Errore apertura file");
                                //ERRORE
                            }

                            // manda dimensione file
                            file_size = lseek(fd, 0, SEEK_END);
                            lseek(fd, 0, SEEK_SET);
                            printf("Lunghezza file %s = %d\n", file_name, file_size);
                            if (write(connfd, &file_size, sizeof(int)) < 0) {
                                perror("write");
                                close(fd);
                                //ERRORE
                            }

                            // 4) Invio del contenuto del file
                            char buffer[DIM_BUFF];
                            int bytes_read;
                            while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                                if (write(connfd, buffer, bytes_read) < 0) {
                                    perror("write");
                                    close(fd);
                                    //ERRORE
                                }
                            }
                            printf("File %s inviato\n", file_name);

                            memset(filePath, 0, sizeof(filePath));
                            close(fd);
                        }

                        // Invia il segnale di fine
                        strcpy(file_name, "FINE");
                        write(connfd, file_name, DIM_BUFF);
                        printf("Client: Directory inviata con successo, torno indietro\n");
                        closedir(dir);
                    }
                    // --- fine invio directory ---                 SNIPPET
                }
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
            len = sizeof(cliaddr);
            memset(dirName, 0, sizeof(dirName)); // Pulizia buffer

            // variabili
            int risultato = 0;
            char buff[DIM_BUFF], dirname[DIM_BUFF], file_name[DIM_BUFF], filePath[DIM_BUFF * 2];
            int nread, file_size;

            // ricezione parametri in ingresso
            if (recvfrom(udpfd, dirName, sizeof(dirName), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                perror("recvfrom");
                continue;
            }
            printf("Servizio UDP: nome directory ricevuto: %s\n", dirName);

            // --- scorre una directory ---                 SNIPPET
            // variabili (da mettere sopra)
            int fd_file;
            struct dirent *entry;
            int result = 0;
            char fullpath[256];

            // apertura directory
            DIR *dir = opendir(dirName);
            if (dir == NULL) {
                perror("Errore nell'aprire la directory");
                //ERRORE
            }

            while ((entry = readdir(dir)) != NULL ) {
                if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                    continue;
                }

                snprintf(fullpath, sizeof(fullpath), "%s/%s", dirName, entry->d_name);
                printf("Analizzo %s\n", entry->d_name);

                // --- scorre contenuto file ---            SNIPPET
                // variabili
                char buffer[1024];
                int bytes_read;
                int line_len = 0;
                char line[1024];

                int fd = open(fullpath, O_RDONLY);
                if (fd == -1) {
                    perror("Errore nell'apertura del file");
                    //ERRORE
                }

                while ((bytes_read = read(fd, buffer, sizeof(buffer))) > 0) {
                    for (int i = 0; i < bytes_read; i++) {
                        if (buffer[i] != '\n') {
                            line[line_len++] = buffer[i];
                        } else {
                            line[line_len] = '\0';
                            line_len = 0;

                            // --- logica di business sulla riga ---
                            int conteggio = 0;
                            for (int j = 0; line[j] != '\0'; j++) {
                                if (line[j] == 'a') {
                                    conteggio++;
                                }
                            }

                            if (conteggio > 3) {
                                risultato++;
                            }
                            // --- fine: logica di business sulla riga ---
                        }
                    }
                }

                if (bytes_read == -1) {
                    perror("Errore nella lettura del file");
                    //ERRORE
                }

                close(fd);
                // --- scorre contenuto file ---            SNIPPET

                // Pulisce la stringa
                memset(fullpath, 0, sizeof(fullpath));
            }
            closedir(dir);
            // --- fine: scorre una directory ---           SNIPPET
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
