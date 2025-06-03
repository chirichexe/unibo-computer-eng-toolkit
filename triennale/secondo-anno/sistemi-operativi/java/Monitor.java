package esercitazione2;


import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Monitor {
	int SINGOLO = 0;
	int COPPIA = 1;
	int MAXB;
	
	private Lock lock = new ReentrantLock();

	private Condition[] codaXXX = new Condition[2];
	private Condition[] codaYYY = new Condition[2];
	private int[] sospXXX = new int[2];
	private int[] sospYYY = new int[2];
	
	public Monitor() {
		
		for (int i = 0; i < 2; i++) {
			codaXXX[i] = lock.newCondition();
			codaYYY[i] = lock.newCondition();
			
			sospXXX[i] = 0;
			sospYYY[i] = 0;
		}

	}
	
	public void esegui(Utente u) throws InterruptedException  {
		lock.lock();
		if (u.tipo == 0) {
			while( true ) {
				System.out.println("Attesa...");
			}
			//System.out.println(u + " con successo");
		}else {
			while( true ) {
				System.out.println("Attesa...");
			}
			//System.out.println(u + " con successo");
		}
		//stampa_stato();
		//lock.unlock();
	}

	private void stampa_stato() {
		System.out.println("XXX: | " + sospXXX[0] + " | " + sospXXX[1] + " |"
				+ "\nYYY: | " + sospYYY[1] + " | " + sospYYY[0] + " |" );
	}
}