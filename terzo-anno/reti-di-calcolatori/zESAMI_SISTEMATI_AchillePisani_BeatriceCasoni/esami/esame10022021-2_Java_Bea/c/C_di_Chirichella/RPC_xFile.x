/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;

struct Riga{
	char id[MAX_NAME_SIZE];
	char data[MAX_NAME_SIZE];
	int giorni;
    char modello[MAX_NAME_SIZE];
	int costo;
    char foto[MAX_NAME_SIZE];
};

struct InputElimina {
    char id[MAX_NAME_SIZE];
};

struct InputNoleggia {
    char id[MAX_NAME_SIZE];
    char data[MAX_NAME_SIZE];
    int giorni;
};

program ESAME_PROG {
    version ESAME_VERS {
        int elimina_sci (InputElimina) = 1;
        int noleggia_sci (InputNoleggia) = 2;
    } = 1;
} = 0x20000014;