/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

const MAX_NAME_SIZE = 256;
const MAX_LIST_SIZE = 6;

struct NomeFile{
	char nome[MAX_NAME_SIZE];
};

struct InputConta {
    char fileName[MAX_NAME_SIZE];
    char linea[MAX_NAME_SIZE];
};

struct OutputLista {
    NomeFile files[MAX_LIST_SIZE];
    int numFiles;
    int status;
};

struct InputLista {
    char dirName[MAX_LIST_SIZE];
    char prefisso[MAX_NAME_SIZE];
};

program ESAME_PROG {
    version ESAME_VERS {
        int conta_occorrenze_linea(InputConta ) = 1;
        struct OutputLista lista_file_prefisso(InputLista) = 2;
    } = 1;
} = 0x20000014;