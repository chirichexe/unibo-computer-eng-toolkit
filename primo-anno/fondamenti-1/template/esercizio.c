///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////

#define _CRT_SECURE_NO_WARNINGS
#include "esercizio.h"
#include "ord.h"
#include "list.h"

#include <stdlib.h>
#include <string.h>

void stampaArrayRicorsivo(XXX* v, int dim) {

	if (dim > 0) {
		printf("Test: %d\n", v[0]);
		stampaArrayRicorsivo(v + 1, dim - 1);
	}
}

void stampaArray(XXX array[], int dim) {
	for (int i = 0;i < dim;i++) {

		printf("\nElemento %d: %d", i, array[i]);
	}
}

XXX* AllocaMemoriaVettore(int dim) {
	if (dim > 0) {
		return (XXX*)malloc(sizeof(XXX) * dim);
	}
	else {
		printf("Errore allocazione memoria!\n");
		return 0;
	}
	
}

void freeVettore(XXX* v) {
	free(v);
}

XXX* riempiVettoreDaAltroVettore(XXX* v, int dim, XXX*v2) {
	for (int i = 0; i < dim; i++) {
		v[i] = v2[i];
	}

	return v;
}

list CreaListaDaVettore(XXX* vettore, int dim) {

	XXX el;
	YYY confr;
	list newList = emptyList();

	for (int i = 0; i < dim; i++) {
		//if (confr condizione el) {
			//newList = cons(confr, newList);
		//}
		
	}

	return newList;
	

}

FILE* ApriFileLettura(char*nomeFile) {
	FILE* fp;
	fp = fopen(nomeFile, "r");
	if(fp==NULL){
		printf("Errore nell'apertura di %s", nomeFile);
		exit(-1);
	}
	else return fp; 
}

FILE* ApriFileScrittura(char* nomeFile) {
	FILE* fp;
	fp = fopen(nomeFile, "w");
	if (fp == NULL) {
		printf("Errore nell'apertura di %s", nomeFile);
		exit(-1);
	}
	else return fp;
}

int ContaRigheFile(FILE* fp) {
	rewind(fp);
	int counter = 0;

	while (!feof(fp)) {
		if (fgetc(fp) == '\n') counter++;

	}
	rewind(fp);
	return counter+1;
}

XXX leggiUnXXX(FILE* fp) {
	//XXX a;
	int i;
	/*
	if (fscanf(fp, "%d %c %f %d %d", &a.id, &a.natura, &a.mq, &a.piano, &a.vani) == 5)
	{
		for (i = 0; i < a.vani; i++) {
			fscanf(fp, "%f", &a.mqVani[i]);
		}
	}
	else
		a.id = -1;
	
		
	return a;
	*/
}


// ------- SCORCIATOIE -------

//SCORRI TUTTA UNA LISTA
/*

 
	int i = 0;
	YYY temp;

	while (!empty(elenco)) {
		temp = head(elenco);
		
		//condizione

		elenco = tail(elenco);
	}
	*/ 

// SCORRI TUTTO UN VETTORE 
/*
	int i;
	XXX temp;
	for(i=0; i<dim; i++){
		
		//condizione
		
		}

	---- OPPURE ---
	
	int i=0;
	XXX temp;

	if (count > 0) {
		while (fscanf(fp, "%d%f%s\n", &(temp.id), &(temp.importo), temp.nome)==3) { //cambia!
			result[i] = temp;
			i++;
		}
	}
	*/

// LETTURA STRINGA CON FGETC
/*

	char ch;
	int i;
	XXX temp;

	while (fscanf(fp, "%s %s %d %f", temp.cliente, temp.fornitore,  &(temp.numeroCopie),
		&(temp.prezzo)) == 4) {

		fgetc(fp);
		ch = fgetc(fp);
		i = 0;
		while (ch != '\n' && ch != EOF) {

			temp.titolo[i] = ch;
			i++;
			ch = fgetc(fp);
		}
		temp.titolo[i] = '\0';
	*/

// LEGGERE TUTTO UN FILE E METTILO IN UN ARRAY DINAMICAMENTE ALLOCATO
/*

XXX* leggiTuttoXXX(char* fileName, int* dim) {

	FILE* fp;
	XXX temp;
	int count = 0;
	XXX* result = NULL;

	fp = ApriFileLettura(fileName);

	count = ContaRigheFile(fp);
	printf("Numero operaizoni %d", count);
	//ho contato le operazioni

	result = AllocaMemoriaVettore(count);
	int i = 0;

	if (count > 0) {
		while (fscanf(fp, "%d%f%s\n", &(temp.id), &(temp.importo), temp.nome)==3) {
			result[i] = temp;
			i++;
		}
	}

	fclose(fp);

	*dim = count;

	return result;
}
*/

//LEGGI TUTTO UN FILE E METTILO IN UNA LISTA
/*

list leggiNegozi(char* fileName) {
	FILE* fp;
	fp = ApriFileLettura(fileName);
	list result = emptyList();

	negozio temp;

	while (fscanf(fp, "%s %c\n", temp.nome, &(temp.tipo)) == 2) {
		result = cons(temp, result);
	}

	fclose(fp);
	return result;
}

*/

//dato un file GIA APERTO, leggi gli elementi, contali e caricali su un "temp"
/*
 contatoreFScanf(FILE*fp, int*array) {

	


	int Numelementi = 0;
	element temp;

	while (fscanf(fp, "%formato", &temp.tipo) == numeroEl) {
		Numelementi++;
	}
	
	rewind(fp);

}
*/

//dato un file GIA APERTO, leggi gli elementi, contali e caricali su una lista di element
/*

registraLista(FILE* fp, int* array) {

	list result = emptyList();
	YYY temp;

	while (fscanf(fp, "%formato", &temp.tipo) == numeroEl) {
		
		result = cons(temp, result);
	}

	rewind(fp);


}
*/

//trova un elemento da lista
/*
Ingrediente trova(Ingrediente* elenco, int dim, char* nome) {
	
	Ingrediente result;
	int i;
	int trovato = 0;
	for (i = 0; i < dim && !trovato; i++) {
		if (strcmp(elenco[i].nome, nome) == 0) {
			trovato = 1;
			result = elenco[i];
		}
	}
	if (!trovato)
		strcpy(result.nome, "NULL");
	return result;
}
*/

//trova un elemento da un array
/*
Ingrediente trova(int id, Ingrediente* ing, int dimI) {
	Ingrediente result;
	int i;
	int trovato;
	strcpy(result.nome, "sconosciuto");
	trovato = 0;
	for (i = 0; i < dimI && !trovato; i++) {
		if (id == ing[i].id) {
			trovato = 1;
			result = ing[i];
		}
	}
	return result;
}
*/

//FILE BINARI
/*
fwrite(addr, int dim, int n, FILE*fp), scritti in memoria a partire dall'indirizzo addr;
fread(addr, int dim, int n, FILE*fp), scritti in memoria a partire dall'indirizzo addr;

*/

// ------ ESERCIZI TIPICI ------

// CASO PARTICOLARE: RICORDATI, QUANDO SCORRI UNA LISTA, DI IMPOSTARE UN PARAMETRO INTERMEDIO CHE LA MEMORIZZI

/*

Appartamento* trovaAppartamento(list appartamenti, int pianoMin, float mqMin, int* dim) {
	list l = appartamenti;
	Appartamento temp;
	Appartamento* result;
	int i;
	*dim = 0;
	while (!empty(l)) {
		temp = head(l);
		if (temp.piano >= pianoMin && temp.mq >= mqMin) {
			*dim = *dim + 1;
		}
		l = tail(l);
	}
	result = (Appartamento*)malloc(sizeof(Appartamento) * (*dim));
	l = appartamenti;
	i = 0;
	while (!empty(l)) {
		temp = head(l);
		if (temp.piano >= pianoMin && temp.mq >= mqMin) {
			result[i] = temp;
			i++;
		}
		l = tail(l);
	}
	bubbleSort(result, *dim);
	return result;


	

*/

// CASO PARTICOLARE: LEGGI UN XXX (con vettore staticamente allocato) - LEGGI TUTTI XXX

/*

Atleta leggiSingoloAtleta(FILE* fp) {
	Atleta a;
	int i;
	int dim;

	if (fscanf(fp, "%s %s", a.codiceAtleta, a.nomeAtleta) == 2){
		dim = 0;
		while (fscanf(fp, "%d ", &a.tempi[dim]) == 1) { dim++; }
		a.dimLog = dim;
	}

	return a;

}

Atleta* leggiAtleti(char fileName[], int* dim) {
	FILE* fp;
	Atleta temp;
	int count = 0;
	Atleta* result = NULL;

	fp = ApriFileLettura(fileName);

	count = ContaRigheFile(fp);
	printf("Numero operaizoni %d", count);
	//ho contato le operazioni

	result = AllocaMemoriaVettore(count);
	int i = 0;

	rewind(fp);
	if (count > 0) {
		for (i = 0; i < count; i++) {
			temp = leggiSingoloAtleta(fp);
			result[i] = temp;
		}
	}

	fclose(fp);

	*dim = count;

	return result;
}

*/

// CASO PARTICOLARE: LEGGI TUTTI XXX ( con vettore dinamicamente allocato, nella struct formatoVett * nomeArr;)

/*
 
list leggiRicette(char* nomeFile) {
	FILE* fp;
	list result;
	Ricetta temp;
	int i;
	result = emptylist();
	fp = fopen(nomeFile, "rt");
	if (fp == NULL) {
		printf("Errore nell'apertura del file %s\n", nomeFile);
		return result;
	}

	else {
		while (fscanf(fp, "%s %d", temp.nome, &(temp.numIngredienti)) == 2) {
			
			temp.ingredienti = (int*)malloc(sizeof(int) * temp.numIngredienti);
			
			i = 0;
			for (i = 0; i < temp.numIngredienti; i++)
				fscanf(fp, "%d", &(temp.ingredienti[i]));
			result = cons(temp, result);
		}
		fclose(fp);
		return result;
	}

}

*/