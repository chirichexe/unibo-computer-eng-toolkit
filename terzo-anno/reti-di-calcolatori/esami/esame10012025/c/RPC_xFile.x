/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 5; /* Massimo di elementi che possono essere restituiti */

struct Matricola{
	char matricola[MAX_NAME_SIZE];
};

struct InputElimina {
    char matricola[MAX_NAME_SIZE];
};

struct OutputVisualizza {
    Matricola risultato [MAX_LIST_SIZE];
    int dimLista;
};

program ESAME_PROG {
    version ESAME_VERS {
        int elimina_prenotazione (InputElimina) = 1;
        struct OutputVisualizza visualizza_multiple ( void ) = 2;
    } = 1;
} = 0x20000014;