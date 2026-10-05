///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////


#ifndef _ORD_H
#define _ORD_H

#include "element.h"
#include "esercizio.h"

//CAMBIA I TIPI DA INT ALLA STRUTTURA "XXX"
void incSwap();
void incComp();
void resetCounters();

void printCounters();

void naiveSort(XXX v[], int n);

void scambia(XXX* a, XXX* b);

int trovaPosMax(XXX v[], int n);

void bubbleSort(XXX v[], int n);

void insertSort(XXX v[], int n);

void insOrd(XXX v[], int pos);

void mergeSort(XXX v[], int first, int last,
	XXX vout[]);

void merge(XXX v[], int i1, int i2,
	int fine, XXX vout[]);



void quickSortR(XXX a[], int iniz, int fine);
void quickSort(XXX a[], int dim);

void quickSortR(XXX a[], int iniz, int fine);

int compare(XXX el1, XXX el2);


#endif 

