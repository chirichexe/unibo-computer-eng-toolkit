/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

const MAX_NAME_SIZE = 30;
const MAX_LIST_SIZE = 5;

struct Matricola{
	char matricola[MAX_NAME_SIZE];
};

struct OutputSoglia {
    Matricola matricole[MAX_LIST_SIZE];
    int numMatricole;
};

program ESAME_PROG {
    version ESAME_VERS {
        int SERVIZIO1(Matricola) = 1;
        struct OutputSoglia SERVIZIO2(int) = 2;
    } = 1;
} = 0x20000014;