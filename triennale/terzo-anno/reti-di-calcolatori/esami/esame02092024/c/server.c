//CHIRICHELLA DAVIDE 0001071414

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

#define IS_UPPERCASE(c) ((c) >= 'A' && (c) <= 'Z')
#define max(a, b) ((a) > (b) ? (a) : (b))

/****************************************************/
typedef struct {
    char directory[MAX_NAME_SIZE];
    char carattere;
    int numOccorrenze;
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

                /* Variabili (sposta sopra) --------------------------------------------- */
                
                char directory[MAX_NAME_SIZE];
                char prefisso[5];

                /* Logica di business --------------------------------------------------- */

                while(1) {
                    if (read(connfd, directory, sizeof(directory)) < 0) {
                        perror("read");
                        close(connfd);
                        exit(1);
                    }

                    int len = read(connfd, prefisso, sizeof(prefisso));
                    if (read(connfd, prefisso, ) < 0) {
                        perror("read");
                        close(connfd);
                        exit(1);
                    }

                    printf("Servizio TCP: Direttorio richiesto: %s, prefisso %s\n", directory, prefisso);

                    /* INVIO DIRECTORY ============================================== SNIPPET */
                    // Variabili (da spostare sopra) -------------------------------------------

                    DIR* dir;
                    int fd, file_size, bytes_read, result = 0;
                    struct dirent *entry;
                    char file_path[MAX_NAME_SIZE * 2];
                    char buffer[MAX_NAME_SIZE];
                    
                    // Algoritmo ---------------------------------------------------------------
                    
                    dir = opendir(directory);
                    // Directory non esiste
                    if (dir == NULL) {

                        printf("Directory non trovata\n");
                        result = -1;
                        if (write(connfd, &result, sizeof(result)) < 0){
                            perror("write");
                            close(connfd);
                            exit(1);
                        }

                    } 
                    // Directory esiste, la scorro
                    else {
                        result = 0;
                        if (write(connfd, &result, sizeof(result)) < 0){
                            perror("write");
                            closedir(dir);
                            close(connfd);
                            exit(1);
                        }     
                        while ((entry = readdir(dir)) != NULL) {
                            if (entry -> d_name[0] == '.' || strncmp(entry -> d_name, prefisso, strlen(prefisso)) != 0 ){
                                continue;
                            }

                            snprintf(file_path, sizeof(file_path), "%s/%s", directory, entry -> d_name);
                            printf("Trovato file %s\n", file_path);

                            // Apertura file
                            fd = open(file_path, O_RDONLY);
                            if (fd < 0) {
                                perror("open");
                                continue;
                            }

                            // Calcolo dimensione file
                            file_size = lseek(fd, 0, SEEK_END);
                            lseek(fd, 0, SEEK_SET);

                            // Invio nome file
                            if (write(connfd, entry -> d_name, MAX_NAME_SIZE) < 0) {
                                perror("write");
                                close(fd);
                                closedir(dir);
                                close(connfd);
                                exit(1);
                            }    

                            // Invio dimensione file
                            if (write(connfd, &file_size, sizeof(int)) < 0) {
                                perror("write");
                                close(fd);
                                closedir(dir);
                                close(connfd);
                                exit(1);
                            }


                            // Invio contenuto
                            while ((bytes_read = read(fd, buffer, MAX_NAME_SIZE)) > 0) {
                                if (write(connfd, buffer, bytes_read) < 0) {
                                    perror("write");
                                    close(fd);
                                    closedir(dir);
                                    close(connfd);
                                    exit(1);
                                }
                            }

                            // File inviato, chiudo
                            close(fd);

                        }

                        // Invio segnale di fine e chiudo directory
                        if (write(connfd, "FINE", 5) < 0) {
                            perror("write");
                            closedir(dir);
                            close(connfd);
                            exit(1);
                        }

                        closedir(dir);
                    }

                    /* FINE INVIO DIRECTORY ========================================= SNIPPET */
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

            /* Variabili (da spostare sopra) ------------------------------------------------------------ */
            len = sizeof(cliaddr);
            int risultato;
            static InvioUDP invioUDP;

            /* Logica di business --------------------------------------------------- */

            risultato = 0;

            while(1){
                
                if (recvfrom(udpfd, &invioUDP, sizeof(invioUDP), 0, (struct sockaddr *)&cliaddr, &len) < 0) {
                    perror("recvfrom");
                    continue;
                }

                printf("Servizio UDP: Messaggio ricevuto: %s %c %d\n", 
                    invioUDP.directory, 
                    invioUDP.carattere, 
                    invioUDP.numOccorrenze 
                );

                // SCORRE UNA DIRECTORY ================================== SNIPPET
                // Variabili -----------------------------------------------------
                int fd_file, i;
                struct dirent *entry;
                char fullpath[MAX_NAME_SIZE];
                DIR *dir;

                // Algoritmo -----------------------------------------------------
                dir = opendir(invioUDP.directory);
                if (dir == NULL) {
                    perror("Errore nell'aprire la directory");
                    risultato= -1;
                } else {
                    while ((entry = readdir(dir)) != NULL ) {
                        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                            continue;
                        }
                        snprintf(fullpath, sizeof(fullpath), "%s/%s", invioUDP.directory, entry->d_name);

                        printf("Analizzo %s\n", entry->d_name);
                        // CONTA LINEE CARATTERE SOGLIA ====================== SNIPPET
                        // Variabili (dichiarate in alto) ---------------------------
                        int fd = -1;
                        char primoCarattere = '\0';
                        int is_new_line = 1;
                        int bytes_read = 0;
                        int count = 0;
                        char buffer[DIM_BUFF];
                        int valid;
                        char c;

                        // Algoritmo ------------------------------------------------
                        fd = open(fullpath, O_RDONLY);
                        if (fd < 0) {
                            perror("Errore apertura file");
                        } else {
                            // Scorro il file 
                            while ((bytes_read = read(fd, buffer, DIM_BUFF)) > 0) {
                                for ( i = 0; i < bytes_read; ++i ) {
                                    c = buffer[i];

                                    valid = 1;
                                    // Se è un carattere ascii
                                    if ( c < 0 || c > 127 ){
                                        valid = 0; // non è ascii
                                    }

                                    // Aggiorna primo carattere all'inizio della riga
                                    if (is_new_line) {
                                        primoCarattere = c;
                                        is_new_line = 0;
                                    }

                                    // Condizione sul carattere della riga
                                    if (c == invioUDP.carattere) {
                                        count++;
                                    }

                                    // Condizione sulla riga e sul primo carattere
                                    if (c == '\n') {
                                        if (count >= invioUDP.numOccorrenze && IS_UPPERCASE(primoCarattere) && valid ) {
                                            risultato++;
                                        }
                                        count = 0;
                                        is_new_line = 1;
                                    }
                                }
                            }

                            if (bytes_read < 0) {
                                perror("Errore lettura file");
                            }

                            close(fd);
                        }
                        memset(fullpath, 0, sizeof(fullpath)); // Ripristina fullpath

                        // FINE CONTA LINEE CARATTERE SOGLIA ================== SNIPPET
                    }
                    closedir(dir);
                }

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