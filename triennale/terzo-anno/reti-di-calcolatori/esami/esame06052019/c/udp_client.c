/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

#include <dirent.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define MAX_LIST_SIZE 7
#define MAX_NAME_SIZE 256
#define DIM_BUFF 1024

/****************************************************/

typedef struct {
    char filename[MAX_NAME_SIZE];
    char dato2;
    int  dato3;
} InvioUDP;

/****************************************************/

int main(int argc, char **argv)
{
    int     sd, nread, port, len;
    struct  hostent *host;
    struct  sockaddr_in clientaddr, servaddr;

    /* CONTROLLO ARGOMENTI ---------------------------------- */
    if ( argc != 3 )
    {
        printf("Error:%s server_host server_port \n", argv[0]);
        exit(1);
    }

    /* INIZIALIZZAZIONE INDIRIZZO SERVER--------------------- */
    memset((char *)&servaddr, 0, sizeof(struct sockaddr_in));
    servaddr.sin_family = AF_INET;
    host = gethostbyname(argv[1]);
    if (host == NULL)
    {
        printf("%s not found in /etc/hosts\n", argv[1]);
        exit(2);
    }

    nread = 0;
    while (argv[2][nread] != '\0')
    {
        if ((argv[2][nread] < '0') || (argv[2][nread] > '9'))
        {
            printf("Secondo argomento non intero\n");
            exit(2);
        }
        nread++;
    }
    port = atoi(argv[2]);
    if (port < 1024 || port > 65535)
    {
        printf("Porta scorretta...");
        exit(2);
    }

    servaddr.sin_addr.s_addr = ((struct in_addr *)(host->h_addr_list[0]))->s_addr;
    servaddr.sin_port = htons(port);

    /* INIZIALIZZAZIONE INDIRIZZO CLIENT--------------------- */
    memset((char *)&clientaddr, 0, sizeof(struct sockaddr_in));
    clientaddr.sin_family = AF_INET;
    clientaddr.sin_addr.s_addr = INADDR_ANY;
    clientaddr.sin_port = 0;

    printf("Client avviato\n");

    /* CREAZIONE SOCKET ---------------------------- */
    sd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sd < 0)
    {
        perror("apertura socket");
        exit(3);
    }
    printf("Creata la socket sd=%d\n", sd);

    /* BIND SOCKET, a una porta scelta dal sistema --------------- */
    if (bind(sd, (struct sockaddr *)&clientaddr, sizeof(clientaddr)) < 0)
    {
        perror("bind socket ");
        exit(1);
    }
    printf("Client: bind socket ok, alla porta %i\n", clientaddr.sin_port);

    /* CORPO DEL CLIENT: ========================================== */
    
    /* Variabili -------------------------------------------------- */
    len = sizeof(servaddr);

    static InvioUDP invioUDP;
    char numString[MAX_NAME_SIZE];
    int result;

    /* Ricezioni fino a EOF --------------------------------------- */
    printf("Inserisci filename: \n");
    while( gets(invioUDP.filename) ) {

        if (strlen(invioUDP.filename) == 0){
            printf("Stringa vuota!");
            printf("Inserisci filename: \n");
            continue;
        }

        // Invio del dato in input-----------------------------------------
        if (sendto(sd, &invioUDP, sizeof(invioUDP), 0, (struct sockaddr *)&servaddr, len) < 0) {
            perror("sendto");
            close(sd);
            exit(1);
        }

        // Ricezione risultato
        if (recvfrom(sd, &result, sizeof(result), 0, (struct sockaddr *)&servaddr, &len) < 0) {
            perror("recvfrom");
            close(sd);
            exit(1);
        }

        // Stampo il risultato e ricomincio il ciclo
        printf("Ricevuto il risultato %d\n", result);

        printf("Inserisci filename: \n");

    } /* ricevuto EOF */
    
    /* FINE CORPO DEL CLIENT ====================================== */

    printf("\nClient: termino...\n");
    shutdown(sd, 0);
    shutdown(sd, 1);
    close(sd);
    exit(0);
}