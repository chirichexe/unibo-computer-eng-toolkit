/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 15;

struct Riga{
	char id[MAX_NAME_SIZE];
	char data[11];
	int giorni;
	char modello[MAX_NAME_SIZE];
    int costoG;
    char nomeFileFoto[MAX_NAME_SIZE];
};

struct InputElimina {
    char id[MAX_NAME_SIZE];
};

struct InputVisualizza {
     char id[MAX_NAME_SIZE];
     char giorno[2];
     char mese[2];
     char anno[4];
     char giorniDurata[2];
};

/*
struct OutputVisualizza {
    Riga prenotazioni[MAX_LIST_SIZE];
    int numPrenotazioni;
};*/

//struct OutputVisualizza
program ESAME_PROG {
    version ESAME_VERS {
        int noleggia_sci(InputVisualizza) = 1;
        int elimina_sci(InputElimina) = 2;
    } = 1;
} = 0x20000014;