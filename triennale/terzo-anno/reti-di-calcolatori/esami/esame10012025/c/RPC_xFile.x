/* CHIRICHELLA DAVIDE 0001071414 */

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