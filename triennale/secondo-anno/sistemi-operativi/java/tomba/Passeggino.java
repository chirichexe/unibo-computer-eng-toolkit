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
