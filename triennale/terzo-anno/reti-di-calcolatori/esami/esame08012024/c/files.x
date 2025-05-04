/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

const MAX_FILE_NAME = 30;
const MAX_FILE_LIST = 7;

struct FileName{
	char name[MAX_FILE_NAME];
};

struct InputElimina {
    char fileName[MAX_FILE_NAME];
};

struct InputLista {
    char dirName[MAX_FILE_NAME];
    char carattere;
    int numOccorrenze;
};

struct OutputLista {
    FileName nomiFile[MAX_FILE_LIST];
    int numFile;
    int status;
};

struct OutputElimina {
    int numEliminati;
};

program ESAME_PROG {
    version ESAME_VERS {
        struct OutputLista LISTA_FILE_CARATTERE(InputLista) = 1;
        struct OutputElimina ELIMINA_OCCORRENZE(InputElimina) = 2;
    } = 1;
} = 0x20000014;