/* CHIRICHELLA DAVIDE 0001071414 */

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