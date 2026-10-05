/*
 * Nome Cognome - Matricola 0000000000
 * Numero prova d'esame: SOSTITUISCI
 *
 * Fondamenti di Informatica T-1 - A.A. 2022-2023
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

#include "element.h"

#ifndef LIST_H
#define LIST_H


typedef struct list_element {
	element value;
	struct list_element* next;
} item;
typedef item* list;

list emptyList(void); // PRIMITIVE

boolean empty(list);

element head(list);

list tail(list);

list cons(element, list);

void showList(list); // NON PRIMITIVE

void freelist(list l);

list delete(element el, list l);

int member(element el, list l);

element sommael(list);

int select(list l, int pos);

list append(list l1, list l2);

list reverse(list l);

list copy(list l);

list delete(element el, list l);

list noripetizione(list l);

int presente(element el, list l);

int contatore_lista(list l);

list insert(int e, list l);

list intersect(list l1, list l2);

list diff(list l1, list l2);

#endif