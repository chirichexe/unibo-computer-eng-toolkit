///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////

#ifndef _ESERCIZIO_H
#define _ESERCIZIO_H

#include"element.h"
#include"list.h"



void stampaArrayRicorsivo(XXX* v, int dim);
void stampaArray(XXX array[], int dim);

XXX* AllocaMemoriaVettore(int dim);
void freeVettore(XXX* v);
XXX* riempiVettoreDaAltroVettore(XXX* v, int dim, XXX* v2);

FILE* ApriFileLettura(char* nomeFile);
FILE* ApriFileScrittura(char* nomeFile);

int ContaRigheFile(FILE*fp);
list CreaListaDaVettore(XXX* vettore, int dim);



#endif