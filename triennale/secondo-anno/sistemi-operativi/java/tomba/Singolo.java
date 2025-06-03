import java.util.Random;

public class Singolo extends Thread {

	private Random r;
	private Monitor m;
	private int Id;


	public Singolo(Random r,Monitor m, int id) {
		
		this.r = r;
		this.m = m;
		this.Id=id;
	}


	public void run() {
		try {
			Thread.sleep(100*r.nextInt(5));
			m.entraSingolo(Id, m.IN);
			Thread.sleep(100*r.nextInt(5));
			m.esciSingolo(Id, m.IN);
			Thread.sleep(100*r.nextInt(5));
			m.entraSingolo(Id, m.OUT);
			Thread.sleep(100*r.nextInt(5));
			m.esciSingolo(Id, m.OUT);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
