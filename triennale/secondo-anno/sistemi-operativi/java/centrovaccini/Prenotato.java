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