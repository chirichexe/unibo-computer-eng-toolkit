///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////

#include "ord.h"
#include "element.h"
#include <string.h>
#include <stdio.h>




int swap_count = 0;
int comp_count = 0;
void incSwap() { swap_count++; }
void incComp() { comp_count++; }
void resetCounters()
{
	swap_count = 0;
	comp_count = 0;
}
void printCounters()
{
	printf("Numero di confronti effettuati: %d\n", comp_count);
	printf("Numero di scambi effettuati: %d\n", swap_count);
}
//ALGORITMI COMMENTATI, cambia i tipi in ord.h


//COMPARE - ESEMPI

/*
A DUE PARAMETRI, ORDINE DECRESCENTE

	int compare(Appartamento a1, Appartamento a2) {
	int result;

	result = (a2.piano - a1.piano); //uguaglianza = 0; ordine decrescente = 1
	if (result == 0) {
		if (a1.mq > a2.mq)
			result = -1;
		else
			if (a1.mq < a2.mq)
				result = 1;
			else
				result = 0;
	}

	return result;
}


int compare(giocatore g1, giocatore g2) {
	int val = 0;
	if (g1.altezza > g2.altezza) { val = 1; }
	else if (g1.altezza < g2.altezza) { val = -1; };

	if (val == 0) {
		if (g1.anno < g2.anno) { val = 1; }
		else if (g1.anno > g2.anno) { val = -1; };

	}

	if (val == 0) {
		if (strcmp(g1.nome, g2.nome) > 0) { val = 1; }
		else if (strcmp(g1.nome, g2.nome) < 0) { val = -1; };

	}

	return val;
}


*/

//SCAMBIA
/*
void scambia(XXX* a, XXX* b) { //Cambia i tipi
	XXX temp;
	temp = *a;
	*a = *b;
	*b = temp;
	incSwap();
}
*/

//NAIVE SORT

/*

void naiveSort(XXX v[], int n) {
	int p;
	while (n > 1) {
		p = trovaPosMax(v, n);
		if (p < n - 1) scambia(&v[p], &v[n - 1]);
		n--;
	}

	for (int i = 0;i < n;i++) {
		printf("%d", v[i]);
	}
}
*/

//TROVAPOSMAX

/*

int trovaPosMax(XXX v[], int n) {
	int i, posMax = 0;
	for (i = 1; i < n; i++)
		if (v[posMax] < v[i]) posMax = i;
	return posMax;
}
*/

//BUBBLE SORT 

/*

void bubbleSort(XXX v[], int n) {
	int i, ordinato = 0;
	while (n > 1 && !ordinato) {
		ordinato = 1;
		for (i = 0; i < n - 1; i++)
			if (v[i] > v[i + 1]) { //Inserisci funzione compare
				scambia(&v[i], &v[i + 1]); //cambia i tipi di scambia
				ordinato = 0;
			}
		n--;
	}
}
*/

//MERGE SORT

/*
void merge(XXX v[], int i1, int i2, int fine, XXX vout[]) {
	int i = i1, j = i2, k = i1;
	while (i <= i2 - 1 && j <= fine) {
		if (v[i] < v[j]) //funzione compare
			vout[k] = v[i++];
		else
			vout[k] = v[j++];
		k++;
	}
	while (i <= i2 - 1) { vout[k] = v[i++]; k++; }
	while (j <= fine) { vout[k] = v[j++]; k++; }
	for (i = i1; i <= fine; i++) v[i] = vout[i];
}
void mergeSort(XXX v[], int first, int last, XXX vout[]) {
	int mid;
	if (first < last) {
		mid = (last + first) / 2;
		mergeSort(v, first, mid, vout);
		mergeSort(v, mid + 1, last, vout);
		merge(v, first, mid + 1, last, vout);
	}
}
*/

//INSERT SORT

/* 
void insertSort(XXX v[], int n) {
	int k;
	for (k = 1; k < n; k++)
		insOrd(v, k);
}

void insOrd(XXX v[], int pos) {
	int i = pos - 1, x = v[pos];
	while (i >= 0 && x < v[i]) {
		v[i + 1] = v[i]; // crea lo spazio 
		i--;
	}
	v[i + 1] = x; // inserisce l’elemento 


	
}

*/

//QUICK SORT

/*
void quickSortR(XXX a[], int iniz, int fine); //cambia tipo
void quickSort(XXX a[], int dim) //cambia tipo
{
	quickSortR(a, 0, dim - 1);
}

void quickSortR(XXX a[], int iniz, int fine) 
{
	int i, j, iPivot;
	XXX pivot; //da cambiare con tipo
	if (iniz < fine)
	{
		i = iniz;
		j = fine;
		iPivot = fine;
		pivot = a[iPivot];
		//do  trova la posizione del pivot 
		{
			while (i < j && a[i] <= pivot) i++; //funzione compare
			while (j > i && a[j] >= pivot) j--; //funzione compare
			if (i < j) scambia(&a[i], &a[j]);
		} while (i < j);

		if (i != iPivot && a[i] != a[iPivot]) //funzione compare
		{
			scambia(&a[i], &a[iPivot]); //cambia i tipi di scambia
			iPivot = i;
		}
		// ricorsione sulle sottoparti, se necessario 
		if (iniz < iPivot - 1){
			quickSortR(a, iniz, iPivot - 1);
	}
		if (iPivot + 1 < fine) {
			quickSortR(a, iPivot + 1, fine);
		}
	} // (iniz < fine) //
} // quickSortR 

*/


