/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

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
    char input[MAX_NAME_SIZE];
    char buff[DIM_BUFF], file_name[DIM_BUFF];
    int result, file_size;
    
    /* Ricezioni fino a EOF --------------------------------------- */
    printf("Inserisci modello: \n");
    while( gets(input) ) {
        
        if (write(sd, input, strlen(input)) < 0) {
            perror("write");
            exit(1);
        }
        memset(input, 0, MAX_NAME_SIZE);


        while(1) {
            if (read(sd, buff, DIM_BUFF) < 0) {
                perror("read");
                exit(1);
            }
            if (strcmp(buff, "FINE") == 0) {
                printf("Terminato...\n");
                break;
            }
            printf("Ricevuto %s\n", buff);
            memset(buff, 0, DIM_BUFF);

            
        }
        // Ricezione risposta ---------------------------------------------------


    } /* ricevuto EOF */
    
    /* FINE CORPO DEL CLIENT ============================== */

    printf("Chiudo connessione\n");
    shutdown(sd, 0);
    close(sd);

}