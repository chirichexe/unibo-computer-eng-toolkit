/* CHIRICHELLA DAVIDE 0001071414 */

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 6; /* Massimo di elementi che possono essere restituiti */

struct FileName{
	char filename[MAX_NAME_SIZE];
};

struct InputM1 {
    char elemento1[MAX_NAME_SIZE];
};

struct InputM2 {
    char elemento2[MAX_NAME_SIZE];
};

struct OutputM2 {
    FileName elementi[MAX_LIST_SIZE];
    int dimLista;
};

program ESAME_PROG {
    version ESAME_VERS {
        int SERVIZIO1 (InputM1) = 1;
        struct OutputM2 SERVIZIO2 (InputM2) = 2;
    } = 1;
} = 0x20000014;