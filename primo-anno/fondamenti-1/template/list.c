///////////////////////////////////////////////////////////
//         Nome Cognome
//		   Numero Matricola: 0000000000
//		   Numero prova Esame: SOSTITUISCI
//
////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include "list.h"
#include "element.h"

 /* ---- PRIMITIVE ---- */


list emptyList(void) { return NULL; }


boolean empty(list l) {
	if (l == NULL) return true;
	else return false;
}

element head(list l) {
	if (empty(l)) exit(1);
	else return l->value;
}

list tail(list l) {
	if (empty(l)) exit(1);
	else return l->next;
}

list cons(element e, list l) {
	list t;
	t = (list)malloc(sizeof(item));
	t->value = e; 
	t->next = l; 
	return t;
}

void freelist(list l) {
	if (empty(l))
		return;
	else {
		freelist(tail(l));
		free(l);
	}
	return;
}




/* 

//---- NON PRIMITIVE,  SOSTITUISCI OGNI VOLTA ---- 

void showList(list l) {
	printf("[");
	while (!empty(l)) {
		printf(" %d", head(l));
		l = tail(l);
		if (!empty(l)) printf(", ");
	} printf("]\n");
}


int memberStringa(element el, list l) {
	element temp;
		if (!empty(l)) {
			temp = head(l);
			if (strcmp(temp.titolo, el.titolo) == 0) return 1;

		else return member(el, tail(l));
	}
		else return 0;
}

int member(element el, list l) {
	int result = 0;
	while (!empty(l) && !result) {
		result = (el.id == head(l).id);
		if (!result)
			l = tail(l);
	}
	return result;
}

int contatore_lista(list l) { //conta i nodi della lista data
	int i = 0;
	while (l != NULL) {
		l = tail(l);
		i++;
	}
	return i;
}


//crea una lista senza ripetizioni //lista già data
list noripetizione(list l) {
	list l_1 = emptyList();
	while (empty(l) == false) {
		element temp = head(l);
		if (presente(temp, tail(l)) == 0) {
			l_1 = cons(temp, l_1);
		}
		l = tail(l);
	}
	return l_1;
}
//elemento presente in lista? presente = 1, assente = 0...serve per noripetizione()


int presente(element el, list l) { //attenzione ad int(è il tipo di el1)....puoi utilizzare un parametro alla volta della struttura
	int trovato = 0;
	while (empty(l) == false && trovato == 0) {
		if (head(l) == el) { //se vuoi definire la presenza attraverso una stringa devi strivere (strcmp(el.nome, head(l).nome) //ATTENZIONE A "nome"
			trovato = 1;
		}
		l = tail(l);
	}
	return trovato;
}



list delete(element el, list l) {
	if (empty(l)) return emptyList();
	else if (el == head(l)) return tail(l);
	else return cons(head(l), delete(el, tail(l)));
}



//Restituisce una lista che è copia della lista data
list copy(list l) {
	if (empty(l)) return l;
	else return cons(head(l), copy(tail(l)));
}

//Restituisce una lista che è concatenamento delle due liste date


list append(list l1, list l2) {
	if (empty(l1)) return l2;
	else return cons(head(l1), append(tail(l1), l2));
}


//Restituisce una lista che è l’inverso della lista data

list reverse(list l) {
	if (empty(l)) return emptyList();
	else return append(reverse(tail(l)),
		cons(head(l), emptyList()));
}



//funzione ricorsiva che trova il valore nella posizone data (posizione si conta da 1)

int select(list l, int pos) {
	if (empty(l)==true) {
		return -1;
	}
	else {
		if (pos!=1) {
			select(tail(l), --pos);
		}
		else {
			return l->value;
		}
	}
}

list insert(int e, list l) {
	list t;
	t = (list)malloc(sizeof(item));
	t->value = e; t->next = l;
	return t;
}


boolean contains(list l, element e)
{
	boolean found = false;
	while (!empty(l) && !found)
	{
		found = (head(l) == e);
		l = tail(l);
	}
	return found;
}

list intersect(list l1, list l2) {
	element cur;
	list intersection = emptyList();
	while (!empty(l1)) {
	//converrebbe iterare sulla lista più corta...{
	cur = head(l1);
	if (contains(l2, cur)) //&& !contains(intersection, cur)per evitare elementi ripetuti nel risultato
		intersection = cons(cur, intersection);
	l1 = tail(l1);
}
	return intersection;
}

list diff(list l1, list l2) {
	element cur;
	list difference = NULL, temp;
	while (!empty(l1))
	{
		cur = l1->value;
		if (!contains(l2, cur)) //&& !contains(difference, cur)per evitare elementi ripetuti nel risultato
		{
			temp = (list)malloc(sizeof(item));
			temp->value = cur;
			temp->next = difference;
			difference = temp;
		}
		l1 = l1->next;
	}
	return difference;
}

element sommael(list l1) {
	if (empty(l1)) return NULL;
	else return head(l1) + sommael(tail(l1));
}

*/





