/*
 * Nome Cognome - Matricola 0000000000
 *
 * Sistemi Operativi T - A.A. 2023-2024
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.util.Random;

public class Prenotato extends Thread {

	private final int IN=0;
	private final int OUT=1;
	private Monitor M;
	private Random r;



	public Prenotato(Monitor M, Random R) {

		this.M = M;
		this.r=R;


	}

	public void run() {

		try {
			sleep(r.nextInt(500));
			M.entraP(IN);
			sleep(r.nextInt(1000));
			M.esceP(IN);	
			sleep(r.nextInt(500));
			M.entraP(OUT);
			sleep(r.nextInt(10*1000));
			M.esceP(OUT);	
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

}