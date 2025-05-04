/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <signal.h>
#include <sys/wait.h>

#define DIM_BUFF 256

// Gestore dei processi figli per evitare zombie
void gestore(int signo) {
    wait(NULL);
}

void handle_client(int conn_sd) {
    char buff[DIM_BUFF];
    int nread;

    // Ciclo di ricezione e risposta
    while ((nread = read(conn_sd, buff, DIM_BUFF)) > 0) {
        buff[nread] = '\0';
        printf("Ricevuto dal client: %s", buff);

        // Invia "Ricevuto" al client
        write(conn_sd, "Ricevuto\n", 9);
    }

    close(conn_sd);
    printf("Connessione chiusa con il client\n");
    exit(0);
}

int main(int argc, char *argv[]) {
    int listen_sd, conn_sd;
    const int on = 1;
    int port;
    struct sockaddr_in servaddr, cliaddr;
    socklen_t cliaddr_len = sizeof(cliaddr);

    // 1) Controllo argomenti
    if (argc != 2) {
        printf("Error: %s port\n", argv[0]);
        exit(1);
    } else {
        // Controllo intero
        
        /*
        num = 0;
        while (argv[1][num] != '\0') {
            if ((argv[1][num] < '0') || (argv[1][num] > '9')) {
                printf("Secondo argomento non intero\n");
                exit(2);
            }
            num++;
        }
        */

        port = atoi(argv[1]);
        if (port < 1024 || port > 65535) {
            printf("Error: %s port\n", argv[0]);
            printf("1024 <= port <= 65535\n");
            exit(2);
        }
    }

    // 2) Impostazione indirizzo server
    memset((char*)&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = INADDR_ANY;
    servaddr.sin_port        = htons(port);

    // 3) Creazione socket di ascolto
    listen_sd = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_sd < 0) {
        perror("Errore: fallita la creazione della socket");
        exit(1);
    }
        // 3.1) Settaggi opzioni socket d'ascolto
        if (setsockopt(listen_sd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0) {
            perror("Errore: set opzioni socket d'ascolto fallito");
            exit(1);
        }
        printf("Server: creata la socket con le rispettive opzioni, fd=%d\n", listen_sd);

    // 4) Bind socket di ascolto
    if (bind(listen_sd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
        perror("Errore: bind fallito");
        close(listen_sd);
        exit(1);
    }

    // 5) Creazione coda d'ascolto
    if (listen(listen_sd, 5) < 0)
    {
        perror("Errore: listen fallita");
        exit(1);
    }
    printf("Server: Sono correttamente in ascolto...\n");

    // 6) Gestore per SIGCHLD per evitare zombie
    signal(SIGCHLD, gestore);

    // 7) Ciclo di accettazione richieste
    while (1) {
        conn_sd = accept(listen_sd, (struct sockaddr *)&cliaddr, &cliaddr_len);
        if (conn_sd < 0) {
            if (errno == EINTR) {
                perror("Server: Forzo la continuazione della accept");
                continue;
            } else
                exit(1);
        }
        printf("Connessione accettata\n");

        if (fork() == 0) {
            // Processo figlio
            close(listen_sd);
            handle_client(conn_sd);
        }

        // Processo padre
        close(conn_sd);
    }

    close(listen_sd);
    return 0;
}
