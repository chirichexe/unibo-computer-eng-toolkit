/*
 * Nome Cognome - Matricola 0000000000
 *
 * Sistemi Operativi T - A.A. 2023-2024
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.util.Random;

public class Passeggino extends Thread {

	private Random r;
	private Monitor m;
	private int Id;


	public Passeggino(Random r,Monitor m, int id) {

		this.r = r;
		this.m = m;
		this.Id=id;
	}



	public void run() {
		try {
			Thread.sleep(100*r.nextInt(5));
			m.entraPasseggino(Id, m.IN);
			Thread.sleep(100*r.nextInt(5));
			m.esciPasseggino(Id, m.IN);
			Thread.sleep(100*r.nextInt(5));
			m.entraPasseggino(Id, m.OUT);
			Thread.sleep(100*r.nextInt(5));
			m.esciPasseggino(Id, m.OUT);
		} catch (InterruptedException e) {}
	}
}
