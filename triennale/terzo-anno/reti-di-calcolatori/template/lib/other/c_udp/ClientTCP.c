/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>

#define DIM_BUFF 256

int main(int argc, char *argv[]) {
    int sd, port;
    char buff[DIM_BUFF];
    struct sockaddr_in servaddr;
    struct hostent *host;

    // 1) Controllo argomenti
    if (argc != 3) {
        printf("Errore: %s serverAddress serverPort\n", argv[0]);
        exit(1);
    }

    // 2) Inizializzazione indirizzo server
    memset((char *)&servaddr, 0, sizeof(struct sockaddr_in));
    servaddr.sin_family = AF_INET;
    host                = gethostbyname(argv[1]);

    // 3) Verifica porta e hostname
    port = atoi(argv[2]);

    if (port < 1024 || port > 65535) {
        printf("Errore: %s = porta scorretta...\n", argv[2]);
        exit(2);
    }
    if (host == NULL) {
        printf("Errore: %s not found in /etc/hosts\n", argv[1]);
        exit(2);
    } else {
        servaddr.sin_addr.s_addr = ((struct in_addr *)(host->h_addr))->s_addr;
        servaddr.sin_port        = htons(port);
    }

    // 4) Creazione socket
    sd = socket(AF_INET, SOCK_STREAM, 0);
    if (sd < 0) {
        perror("Errore: creazione socket fallita");
        exit(1);
    }

    // 5) Connessione al server
    if (connect(sd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
        perror("Errore: connect fallita");
        exit(1);
    }

    // 6) Invio messaggi
    printf("Client: Inserisci messaggio (CTRL+D per terminare): ");
    while (fgets(buff, DIM_BUFF, stdin) != NULL) {
        // Invia messaggio al server
        if (write(sd, buff, strlen(buff)) < 0) {
            perror("Errore: invio messaggio fallito");
            close(sd);
            return 0;
        }

        // Ricezione conferma dal server
        int nread = read(sd, buff, DIM_BUFF);
        if (nread > 0) {
            buff[nread] = '\0';
            printf("Server: %s\n", buff);
        } else {
            perror("Errore: ricezione messaggio fallita");
            close(sd);
            return 0;
        }

        // Ricomincio ciclo
        printf("Inserisci messaggio (CTRL+D per terminare): ");
    }

    // 7) Chiusura socket
    close(sd);
    printf("Connessione chiusa.\n");
    return 0;
}
