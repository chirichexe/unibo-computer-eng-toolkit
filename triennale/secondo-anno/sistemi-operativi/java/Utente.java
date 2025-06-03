package esercitazione2;

import java.util.Random;

public class Utente  extends Thread {
	private Random r;
	private Monitor M;
	private int id;
	public int tipo;

	public Utente(Monitor M, int tipo, int id) {
		this.M = M;
		this.tipo=tipo;
		this.id = id;
		
		r = new Random();
	}

	@Override
	public String toString() {
		return "UT" + id + (tipo == 0 ? "-C" : "-S");
	}

	public void run() {
		try {
				sleep(r.nextInt(1000));
				M.esegui(this);
			} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

}