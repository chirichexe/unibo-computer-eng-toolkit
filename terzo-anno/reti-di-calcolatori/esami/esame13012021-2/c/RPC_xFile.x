/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 6; /* Massimo di elementi che possono essere restituiti */

struct FileName{
	char filename[MAX_NAME_SIZE];
};

struct DirName {
    char dirname[MAX_NAME_SIZE];
};

struct OutputLista {
    DirName elementi[MAX_LIST_SIZE];
    int dimLista;
};

program ESAME_PROG {
    version ESAME_VERS {
        int elimina_occorrenze (FileName) = 1;
        struct OutputLista lista_sottodirettori (DirName) = 2;
    } = 1;
} = 0x20000014;