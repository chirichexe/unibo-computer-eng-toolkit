/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 6;

struct Riga{
	char id[MAX_NAME_SIZE];
	char cartaId[6];
	char marca[7];
	char img[MAX_NAME_SIZE];
};

struct InputElimina {
    char id[MAX_NAME_SIZE];
};

struct InputVisualizza {
    char marca[7];
};

struct OutputVisualizza {
    Riga prenotazioni[MAX_LIST_SIZE];
    int numPrenotazioni;
};

program ESAME_PROG {
    version ESAME_VERS {
        struct OutputVisualizza visualizza_prenotazioni(InputVisualizza) = 1;
        int elimina_monopattino(InputElimina) = 2;
    } = 1;
} = 0x20000014;