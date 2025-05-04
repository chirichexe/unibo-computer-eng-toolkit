/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
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