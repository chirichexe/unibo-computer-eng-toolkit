/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

/* BALLOTTI MATTIA 0001077835 */

const TARGA_SIZE = 8;
const PATENTE_SIZE = 6;
const MAX_TIPO_SIZE = 7;
const CHAR_FOLDER_SIZE = 13; /* = TARGA_SIZE + 5 */
const MAX_PRENOTAZIONI_SIZE = 6;

struct Riga{
	char targa[TARGA_SIZE];
	char patente[PATENTE_SIZE];
	char tipo[MAX_TIPO_SIZE];
    char img[CHAR_FOLDER_SIZE];
};

struct InputVisualizza {
    char tipo[MAX_TIPO_SIZE];
};

struct OutputVisualizza {
    Riga prenotazioni[MAX_PRENOTAZIONI_SIZE];
	int numPrenotazioni;
};

struct InputAggiorna {
    char targa[TARGA_SIZE];
    char patente[PATENTE_SIZE];
};

program ESAME_PROG {
    version ESAME_VERS {
        OutputVisualizza visualizza_prenotazioni(InputVisualizza) = 1;
        int aggiorna_licenza(InputAggiorna) = 2;
    } = 1;
} = 0x20000014;