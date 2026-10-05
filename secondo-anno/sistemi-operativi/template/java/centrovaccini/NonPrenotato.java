/*
 * Nome Cognome - Matricola 0000000000
 *
 * Sistemi Operativi T - A.A. 2023-2024
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.util.Random;

public class NonPrenotato  extends Thread {

	private final int IN=0;
	private final int OUT=1;
	private Monitor M;
	private Random r;
	


	public NonPrenotato(Monitor M, Random R) {

		this.M = M;
		this.r=R;
		

	}

	public void run() {
		boolean OK;
		try {
			sleep(r.nextInt(10*1000));
			OK=M.entraNP(IN);
			if (!OK)
				System.out.println("Utente non prenotato: non ci sono più vaccini e quindi torno a casa!\n ");
			else
			{ 	sleep(r.nextInt(500));
				M.esceNP(IN);	
				sleep(r.nextInt(1000));
				M.entraNP(OUT);
				sleep(r.nextInt(500));
				M.esceNP(OUT);	
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

}