/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 6; /*Massimo di elementi che possono essere restituiti */

struct Riga{
	char DATO1[MAX_NAME_SIZE];
	char DATO2[MAX_NAME_SIZE];
	int DATO3;
};

struct InputM1 {
    char elemento1[MAX_NAME_SIZE];
};

struct InputM2 {
    char elemento2[MAX_NAME_SIZE];
};

struct OutputM2 {
    Riga risultato [MAX_LIST_SIZE];
    int dimLista;
};

program ESAME_PROG {
    version ESAME_VERS {
        int SERVIZIO1 (InputM1) = 1;
        struct OutputM2 SERVIZIO2 (InputM2) = 2;
    } = 1;
} = 0x20000014;
