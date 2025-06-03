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
