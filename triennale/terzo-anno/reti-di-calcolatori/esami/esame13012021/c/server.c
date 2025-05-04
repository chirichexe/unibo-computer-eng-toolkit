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
#define IS_TYPE_TEXT(name) (name[strlen(name)-4] == '.' && name[strlen(name)-3] == 't' && name[strlen(name)-2] == 'x' && name[strlen(name)-1] == 't' ? 1 : 0)

/****************************************************/
typedef struct {
    char carattere;
    int numOccorrenze;
    char dirName[MAX_NAME_SIZE];
} InvioUDP;

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

                /* Logica di business --------------------------------------------------- */

                while(1) {
                    
                    memset(input, 0, sizeof(input));

                    if (read(connfd, input, sizeof(input)) < 0) {
                        perror("read");
                        close(connfd);
                        continue;
                    }

                    printf("Servizio TCP: Messaggio ricevuto: %s\n", input);

                    /* INVIO DIRECTORY ==================================== SNIPPET */

                    // Controllo esistenza -----------------------------------------------                    
                    DIR *dir = opendir(input);
                    if (dir == NULL) {
                        
                        printf("Directory non trovata\n");

                        result = -1;
                        if (write(connfd, &result, sizeof(result)) < 0){
                            perror("write");
                            close(connfd);
                            continue;
                        }

                    } else {

                        result = 0;
                        if (write(connfd, &result, sizeof(result)) < 0){
                            perror("write");
                            close(connfd);
                            continue;
                        }     
                    }

                    // Invio i file -----------------------------------------------

                    struct dirent *entry;
                    char file_name[DIM_BUFF];
                    char file_path[DIM_BUFF * 2];
                    
                    while ((entry = readdir(dir)) != NULL) {
                        if (entry->d_name[0] == '.' || !IS_TYPE_TEXT(entry -> d_name)) continue;

                        memset(file_name, 0, DIM_BUFF);
                        strncpy(file_name, entry->d_name, DIM_BUFF - 1);
                        if (write(connfd, file_name, DIM_BUFF) < 0) {
                            perror("write");
                            closedir(dir);
                            continue;
                        }

                        snprintf(file_path, sizeof(file_path), "%s/%s", input, entry->d_name);
                        int fd = open(file_path, O_RDONLY);
                        if (fd < 0) {
                            perror("open");
                            closedir(dir);
                            continue;
                        }

                        int file_size = lseek(fd, 0, SEEK_END);
                        lseek(fd, 0, SEEK_SET);

                        if (write(connfd, &file_size, sizeof(int)) < 0) {
                            perror("write");
                            close(fd);
                            closedir(dir);
                            continue;
                        }

                        char buffer[DIM_BUFF];
                        int bytes_read;

                        while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                            if (write(connfd, buffer, bytes_read) < 0) {
                                perror("write");
                                close(fd);
                                closedir(dir);
                                continue;
                            }
                        }

                        close(fd);
                    }
                    // Messaggio di fine --------------------------------------------
                    strcpy(file_name, "FINE");
                    write(connfd, file_name, DIM_BUFF);
                    closedir(dir);                  

                    /* FINE INVIO DIRECTORY =============================== SNIPPET */

                    if (write(connfd, &result, sizeof(result)) < 0) {
                        perror("write");
                        close(connfd);
                        continue;
                    }
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
            printf("Ricevuta richiesta UDP\n");

            /* Variabili ------------------------------------------------------------ */
            len = sizeof(cliaddr);
            int risultato = -1;
            static InvioUDP invioUDP;
            struct dirent *entry;
            char buffer[DIM_BUFF];
            char fullpath[DIM_BUFF];
            int bytes_read;
            int count = 0;

            /* Logica di business --------------------------------------------------- */

            while(1){

                if (recvfrom(udpfd, &invioUDP, sizeof(invioUDP), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                    perror("recvfrom");
                    continue;
                }

                printf("Servizio UDP: Messaggio ricevuto: %s %c %d\n", invioUDP.dirName, invioUDP.carattere, invioUDP.numOccorrenze);
                
                // SCORRE UNA DIRECTORY ================================== SNIPPET

                // Algoritmo -----------------------------------------------------
                DIR *dir = opendir(invioUDP.dirName);
                if (dir == NULL) {
                    perror("Errore nell'aprire la directory");
                    risultato = -1;                
                    if (sendto(udpfd, &risultato, sizeof(risultato), 0, (struct sockaddr *)&cliaddr, len) < 0) {
                        perror("sendto");
                        continue;
                    }
                    continue;
                }

                risultato = 0;
                while ((entry = readdir(dir)) != NULL ) {
                    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                        continue;
                    }
                    printf("Analizzo %s\n", entry->d_name);
                    snprintf(fullpath, sizeof(fullpath), "%s/%s", invioUDP.dirName, entry->d_name);

                    // CONTA LINEE CARATTERE SOGLIA ======================
                    // Algoritmo ------------------------------------------------
                    int fd = open(fullpath, O_RDONLY);
                    if (fd < 0) {
                        perror("Errore apertura file");
                        risultato = -1;                
                        if (sendto(udpfd, &risultato, sizeof(risultato), 0, (struct sockaddr *)&cliaddr, len) < 0) {
                            perror("sendto");
                            continue;
                        }
                        continue;
                    }

                    char primoCarattere;
                    while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                        for (int i = 0; i < bytes_read; ++i) {
                            char c = buffer[i];
                            
                            if (i == 0){
                                primoCarattere = buffer[0];
                            }
                            if (c == invioUDP.carattere) {
                                count++;
                            }
                            if (c == '\n') {
                                if (count >= invioUDP.numOccorrenze && islower(primoCarattere)) {
                                    risultato++;
                                }
                                count = 0;
                                primoCarattere = buffer[i + 1];
                            }
                        }
                    }

                    if (bytes_read < 0) {
                        perror("Errore lettura file");
                        close(fd);
                        risultato = -1;                
                        if (sendto(udpfd, &risultato, sizeof(risultato), 0, (struct sockaddr *)&cliaddr, len) < 0) {
                            perror("sendto");
                            continue;
                        }
                        continue;
                    }

                    close(fd);
                    memset(fullpath, 0, sizeof(fullpath));
                    // FINE CONTA LINEE CARATTERE SOGLIA ================= SNIPPET

                }
                closedir(dir);

                // FINE SCORRE UNA DIRECTORY ============================== SNIPPET

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