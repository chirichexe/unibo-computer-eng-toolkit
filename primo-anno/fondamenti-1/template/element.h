///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////

#ifndef _ELEMENT_H
#define _ELEMENT_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h> 

#define DIM 65
#define DIM_2 31


typedef struct {
	char nome2[DIM_2];
}XXX;


typedef struct {
	char nome[DIM];
}YYY;


typedef YYY element;

typedef enum { false, true } boolean;



#endif