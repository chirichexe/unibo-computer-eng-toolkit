/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

const MAX_DIM_NAME = 30;
const MAX_DIM_LIST = 5;

struct Matricola{
	char matricola[MAX_DIM_NAME];
};

struct OutputSoglia {
    Matricola matricole[MAX_DIM_LIST];
    int numMatricole;
};

program ESAME_PROG {
    version ESAME_VERS {
        int ELIMINA_PRENOTAZIONE(Matricola) = 1;
        struct OutputSoglia VISUALIZZA_VOTO_MAGGIORE_SOGLIA(int) = 2;
    } = 1;
} = 0x20000014;