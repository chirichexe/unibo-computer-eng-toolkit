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