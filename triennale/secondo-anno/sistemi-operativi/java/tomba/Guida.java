import java.util.Random;

public class Guida extends Thread {

	private Random r;
	private Monitor m;	
	private int Id;
	private int volte;


	public Guida(Random r,Monitor m, int id) {

		this.r = r;
		this.m = m;
		this.Id=id;
		this.volte=this.r.nextInt(20)+1;
	}



	public void run() {
		while(volte>0)
			try {
				Thread.sleep(100*r.nextInt(5));
				m.entraGuida(Id, m.IN);
				Thread.sleep(100*r.nextInt(5));
				m.esciGuida(Id, m.IN);
				Thread.sleep(100*r.nextInt(5));
				m.entraGuida(Id, m.OUT);
				Thread.sleep(100*r.nextInt(5));
				m.esciGuida(Id, m.OUT);
				volte--;
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
}
