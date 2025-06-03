import java.util.Random;

public class Newgrange {

	public static void main(String[] args) {
		final int MAXTHREAD=10;
		Random r = new Random();
		Monitor m = new Monitor();
		int nSingoli=r.nextInt(MAXTHREAD)+1; // numero thread singoli
		Singolo[] singoli = new Singolo[nSingoli];
		int nPas=r.nextInt(MAXTHREAD)+1; //numero thread passeggino
		Passeggino[] pas = new Passeggino[nPas];
		int nGuide=r.nextInt(MAXTHREAD)+1;
		Guida[] guide = new Guida[nGuide];
		System.out.println("benvenuti alla Newgrange!\n Ci sono "+nSingoli+" Visitatori singoli;\n"+nPas+" Visitatori con passeggino;\n"+nGuide+" Guide.\n\n");
		for (int i = 0; i < nSingoli; i++) {
			singoli[i]=new Singolo(r, m,i);
		}
		for (int i = 0; i < nPas; i++) {
			pas[i]=new Passeggino(r, m,i);
		}		
		for (int i = 0; i < nGuide; i++) {
			guide[i]=new Guida(r, m,i);
		}
		for (int i = 0; i < nSingoli; i++) {
			singoli[i].start();
		}
		for (int i = 0; i < nPas; i++) {
			pas[i].start();
		}		
		for (int i = 0; i < nGuide; i++) {
			guide[i].start();
		}
	}
}
