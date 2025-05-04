/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
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