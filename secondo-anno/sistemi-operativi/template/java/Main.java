/*
 * Nome Cognome - Matricola 0000000000
 *
 * Sistemi Operativi T - A.A. 2023-2024
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package esercitazione2;

import java.util.Random;

public class Main {
	private final static int MAX_U = 30; // numero utenti
	
	public static void main(String[] args) {
		Random R = new Random(System.currentTimeMillis());
		
		Utente [] UTENTI = new Utente[MAX_U];
		
		Monitor M = new Monitor();
		
		for ( int i = 0; i < MAX_U; i++)
		{	
			UTENTI[i] = new Utente(M, R.nextInt(0,2), i);
			System.out.println("Creato utente " + UTENTI[i] );
		}
		
		for ( int i = 0; i < MAX_U; i++)
			UTENTI[i].start();
		}
}
