/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
/// Traccia: NUMTRACCIA
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

#define DIM_BUFF         100
#define LENGTH_FILE_NAME 20

int main(int argc, char *argv[]) {
    int                sd, nread, nwrite, port;
    char               ok, buff[DIM_BUFF], input[DIM_BUFF];
    struct hostent    *host;
    struct sockaddr_in servaddr;

    /* CONTROLLO ARGOMENTI --------------------------------------- */
    if (argc != 3) {
        printf("Error:%s USAGE \n", argv[0]);
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

    /* CORPO DEL CLIENT: ------------------------------------------ */
    
    while(gets(input)) {
        // --- ricezione directory ---                      SNIPPET
        // variabili
        int file_size = 0;
        char file_name[DIM_BUFF];

        // comunico la directory che voglio ottenere
        printf("Voglio ottenre la directory %s\n", input);
        if (write(sd, input, strlen(input))<0){
            perror("write");
            //ERRORE
        }

        // protocollo: p=presente, a=assente
        nread = read(sd, buff, DIM_BUFF);
        if (nread > 0) {
            buff[nread] = '\0';
            if (buff[0] == 'a') {
                printf("Directory %s non presente\n", input);
            } else {  // directory trovata
                while (1) {
                    memset(file_name, 0, DIM_BUFF);
                    if (read(sd, file_name, DIM_BUFF) <= 0) {
                        perror("read");
                        //ERRORE
                    }

                    // directory terminata: esco dal ciclo
                    if (strcmp(file_name, "FINE") == 0) {
                        printf("Ricezione directory completata.\n");
                        break;
                    }

                    if (read(sd, &file_size, sizeof(int)) <= 0) {
                        perror("read");
                        //ERRORE
                    }
                    printf("Ricevuto nome file: %s di lunghezza %d\n", file_name, file_size);

                    // crazione file
                    int fd = open(file_name, O_CREAT | O_WRONLY, 0777);
                    if (fd < 0) {
                        perror("open");
                        //ERRORE
                    }

                    // scrittura contenuto
                    char buffer[DIM_BUFF];
                    int bytes_left = file_size;
                    int bytes_read;
                    while (bytes_left > 0) {
                        bytes_read = read(sd, buffer, (bytes_left < DIM_BUFF) ? bytes_left : DIM_BUFF);
                        if (bytes_read <= 0) {
                            perror("Client:mget: Errore durante la ricezione dei dati del file");
                            close(fd);
                            exit(1);
                        }
                        write(fd, buffer, bytes_read);
                        bytes_left -= bytes_read;
                    }
                    close(fd);
                    
                }
            }

        memset(buff, 0, DIM_BUFF); // Pulisco il buffer
        // --- fine ricezione directory ---             SNIPPET
        }
    }

    /* FINE CORPO DEL CLIENT ------------------------------------------ */

    printf("Chiudo connessione\n");
    shutdown(sd, 0);
    close(sd);

}