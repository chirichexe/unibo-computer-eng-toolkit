/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_DIM_NAME = 30;
const MAX_DIM_LIST = 5;

struct Matricola{
	char matricola[MAX_DIM_NAME];
};

struct OutputSoglia {
    Matricola matricole[MAX_DIM_LIST];
    int numMatricole;
};

program ESAME_PROG {
    version ESAME_VERS {
        int ELIMINA_PRENOTAZIONE(Matricola) = 1;
        struct OutputSoglia VISUALIZZA_VOTO_MAGGIORE_SOGLIA(int) = 2;
    } = 1;
} = 0x20000014;