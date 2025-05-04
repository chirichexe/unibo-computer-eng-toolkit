//CHIRICHELLA DAVIDE 0001071414

#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/select.h>
#include <unistd.h>

#define MAX_LIST_SIZE 7
#define MAX_NAME_SIZE 256
#define DIM_BUFF 1024

int main(int argc, char *argv[]) {
    int                sd, nread, nwrite, port;
    struct hostent    *host;
    struct sockaddr_in servaddr;

    /* CONTROLLO ARGOMENTI --------------------------------------- */
    if (argc != 3) {
        printf("Error:%s server_host server_port \n", argv[0]);
        exit(1);
    }

    /* PREPARAZIONE INDIRIZZO SERVER ----------------------------- */
    memset((char *)&servaddr, 0, sizeof(struct sockaddr_in));
    servaddr.sin_family = AF_INET;
    host                = gethostbyname(argv[1]);
    if (host == NULL) {
        printf("%s not found in /etc/hosts\n", argv[1]);
        exit(2);
    }

    nread = 0;
    while (argv[2][nread] != '\0') {
        if ((argv[2][nread] < '0') || (argv[2][nread] > '9')) {
            printf("Secondo argomento non intero\n");
            exit(2);
        }
        nread++;
    }
    port = atoi(argv[2]);
    if (port < 1024 || port > 65535) {
        printf("Porta scorretta...");
        exit(2);
    }

    servaddr.sin_addr.s_addr = ((struct in_addr *)(host->h_addr_list[0]))->s_addr;
    servaddr.sin_port        = htons(port);

    /* CREAZIONE E CONNESSIONE SOCKET (BIND IMPLICITA) ----------------- */

    sd = socket(AF_INET, SOCK_STREAM, 0);
    if (sd < 0) {
        perror("apertura socket ");
        exit(3);
    }
    printf("Creata la socket sd=%d\n", sd);

    if (connect(sd, (struct sockaddr *)&servaddr, sizeof(struct sockaddr)) < 0) {
        perror("Errore in connect");
        exit(4);
    }
    printf("Connect ok\n");

    /* CORPO DEL CLIENT: ================================================ */

    /* Variabili -------------------------------------------------- */
    char directory[MAX_NAME_SIZE];
    char prefisso[MAX_NAME_SIZE];
    
    /* Ricezioni fino a EOF --------------------------------------- */
    printf("Inserisci nome directory da ricevere: \n");
    while( gets(directory) ) {
        
        printf("Inserisci prefisso: \n");
        gets(prefisso);

        if (strlen(prefisso) > 4){
            printf("Prefisso troppo lungo\n");
            printf("Inserisci nome directory da ricevere: \n");
            continue;
        }

        if (write(sd, directory, strlen(directory)) < 0) {
            perror("write");
            close(sd);
            exit(1);
        }

        if (write(sd, prefisso, strlen(prefisso)) < 0) {
            perror("write");
            close(sd);
            exit(1);
        }

        /* RICEZIONE DIRECTORY ========================================= SNIPPET */
        // Variabili (da spostare sopra) ------------------------------------------

        int result;
        char file_name[MAX_NAME_SIZE];
        int fd, file_size = 0;
        char file_buffer[DIM_BUFF];
        int bytes_read, bytes_left;

        // Algoritmo --------------------------------------------------------------
        if(read(sd, &result, sizeof(result)) < 0) {
            perror("read");
            close(sd);
            exit(1);
        }

        if (result < 0) {
            printf("Directory non presente lato servitore.\n");
            printf("Inserisci nome directory da ricevere\n");
        } else {
            while(1){
                memset(file_name, 0, MAX_NAME_SIZE);

                // Ricevo nome file
                if (read(sd, file_name, MAX_NAME_SIZE) < 0) {
                    perror("read");
                    close(sd);
                    exit(1);
                }

                // Se il nome file è FINE ho terminato ed esco
                if (strcmp(file_name, "FINE") == 0) {
                    printf("Directory ricevuta con successo\n");
                    break;
                }
                
                // Ricevo dimensione file
                if (read(sd, &file_size, sizeof(int)) < 0) {
                    perror("read");
                    close(sd);
                    exit(1);
                }

                printf("Ricevuto file: %s di lunghezza %d\n", file_name, file_size);

                // Creo il file
                fd = open(file_name, O_CREAT | O_WRONLY, 0777);
                if (fd < 0) {
                    perror("open");
                    close(sd);
                    exit(1);
                }

                // Ricevo contenuto ("countdown" sui byte da ricevere)
                bytes_left = file_size;
                while (bytes_left > 0) {
                    bytes_read = read(sd, file_buffer, (bytes_left < MAX_NAME_SIZE) ? bytes_left : MAX_NAME_SIZE);
                    
                    if (bytes_read <= 0) {
                        perror("read");
                        close(sd);
                        close(fd);
                        exit(1);
                    }
                    
                    write(fd, file_buffer, bytes_read);
                    bytes_left -= bytes_read;
                }

                close(fd);
            }
        }
        /* FINE RICEZIONE DIRECTORY ==================================== SNIPPET */

        printf("Inserisci nome directory da ricevere: \n");

    } /* ricevuto EOF */
    
    /* FINE CORPO DEL CLIENT ============================== */

    printf("Chiudo connessione\n");
    shutdown(sd, 0);
    close(sd);
}