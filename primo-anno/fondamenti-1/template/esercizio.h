/*
 * Nome Cognome - Matricola 0000000000
 * Numero prova d'esame: SOSTITUISCI
 *
 * Fondamenti di Informatica T-1 - A.A. 2022-2023
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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