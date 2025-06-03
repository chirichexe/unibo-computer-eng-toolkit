
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Monitor {
	private final int IN = 0;
	private final int OUT = 1;
	private int MAX_C; // capacità corridoio
	private int TOT_JJ; //vaccini JJ
	private int N_P; // numero operatori per prenotati
	private int N_OD; // numero operatori per non prenotati

	private Lock lock = new ReentrantLock();

	private int[] inC = new int[2]; // utenti in corridoio per direzione
	private int TOTC;// persone nel corridoio
	private int LiberiOP; // op. disponibili per prenotati
	private int LiberiON; //op. disponibili per non prenotati

	private Condition[] codaP = new Condition[2];
	private Condition[] codaNP = new Condition[2];

	private int[] sospP = new int[2];
	private int[] sospNP = new int[2];

	public Monitor(int max_c, int tot_jj, int n_p, int n_od) {
		int i;

		this.MAX_C = max_c;
		this.TOT_JJ = tot_jj;
		this.N_P = n_p;
		this.N_OD= n_od;
		TOTC=0;// persone nel corridoio
		LiberiOP=N_P; // op. disponibili per prenotati
		LiberiON=N_OD; //
		for (i = 0; i < 2; i++) {
			inC[i] = 0;
			codaP[i] = lock.newCondition();
			codaNP[i] = lock.newCondition();
			sospP[i] = 0;
			sospNP[i] = 0;
		}

	}

	public void entraP(int d) throws InterruptedException {

		lock.lock();

		if (d == IN) {
			while (TOTC == MAX_C || inC[OUT] > 0 || LiberiOP==0 || sospP[OUT] > 0 || sospNP[OUT] > 0) {

				sospP[IN]++;
				codaP[IN].await();
				sospP[IN]--;

			}

			inC[IN]++;
			TOTC++;
			LiberiOP--; // chi entra nel corridoio occupa l'operatore
			// verifica
			System.out.println("Prenotato entra nel corridoio in dir IN");
			stampa_stato();

		} else // prenotato in uscita
		{
			while (TOTC == MAX_C || inC[IN] > 0  ) {
				sospP[OUT]++;
				codaP[OUT].await();
				sospP[OUT]--;
			}
			inC[OUT]++;
			TOTC++;
			LiberiOP++;
			// verifica
			System.out.println("Prenotato entra nel corridoio in dir OUT");
			stampa_stato();
			// liberato un operatore: non segnalo nessuno in ingresso perchè occupo il corridoio
			

		}
		lock.unlock();
	}

	public boolean entraNP(int d) throws InterruptedException {
		lock.lock();
		if (d == IN) // non prenotato in ingresso
			if (TOT_JJ==0) // i vaccini sono finiti
			{	lock.unlock();
				return false;
				
			}
			else //non prenotato in ingresso: c'è il vaccino
			{		TOT_JJ--; 
					while ( TOTC == MAX_C || inC[OUT] > 0 || LiberiON==0 || sospP[OUT] > 0 || sospNP[OUT] > 0 || sospP[IN]>0)
					{	sospNP[IN]++;
						codaNP[IN].await();
						sospNP[IN]--;
					}
					inC[IN]++;
					TOTC++;
					LiberiON--; // occupo un operatore
					// verifica
					System.out.println("Non Prenotato entra nel corridoio in dir  IN");
					stampa_stato();
				
			}
		else { //non prenotato in uscita
			while (TOTC == MAX_C || inC[IN] > 0 || sospP[OUT] > 0 ) {
				sospNP[OUT]++;
				codaNP[OUT].await();
				sospNP[OUT]--;
			}
			inC[OUT]++;
			TOTC++;
			LiberiON++;;
			// verifica
			System.out.println("Non Prenotato entra nel corridoio in dir OUT");
			stampa_stato();
			//  non faccio signal
			
		}
		lock.unlock();
		return true;

	}

	public void esceP(int d) {

		lock.lock();
		if (d == IN) {
			inC[IN]--;
			TOTC--;
			// verifica
			System.out.println("Prenotato esce dal corridoio in dir IN");
			stampa_stato();
			// eventuali signal a processi in attesa:
			if (inC[IN] == 0 && sospP[OUT] > 0)
				codaP[OUT].signalAll();
			if (inC[IN] == 0 && sospNP[OUT] > 0)
				codaNP[OUT].signalAll();
			// signal a processi in dir IN
			if (sospP[IN] > 0 && inC[OUT] == 0)
				codaP[IN].signal();
			if (sospNP[IN] > 0 && inC[OUT] == 0)
				codaNP[IN].signal();

		} else { // prenotato esce dal corridoio in dir  OUT
			
			inC[OUT]--;
			TOTC--;
			
			if (sospP[OUT] > 0)
				codaP[OUT].signal();
			if (sospNP[OUT] > 0)
				codaNP[OUT].signal();
			// signal a processi in dir IN
			if (sospP[IN] > 0 &&  inC[OUT]==0)
				codaP[IN].signalAll();
			if (sospNP[IN] > 0 && inC[OUT] == 0)
				codaNP[IN].signalAll();
			// verifica
			System.out.println("Prenotato esce dal corrridoio in dir  OUT");
			stampa_stato();
			
		}

		lock.unlock();

	}

	public void esceNP(int d) {

		lock.lock();
		if (d == IN) {
			inC[IN]--;
			TOTC--;
			// verifica
			System.out.println("Non Prenotato esce dal corridoio in dir IN");
			stampa_stato();
			// eventuali signal a processi in attesa:
			if (inC[IN] == 0 && sospP[OUT] > 0)
				codaP[OUT].signalAll();
			if (inC[IN] == 0 && sospNP[OUT] > 0)
				codaNP[OUT].signalAll();
			// signal a processi in dir IN
			if (sospP[IN] > 0 && inC[OUT] == 0)
				codaP[IN].signal();
			if (sospNP[IN] > 0 && inC[OUT] == 0)
				codaNP[IN].signal();

		} else { // non prenotato esce dal corridoio in dir  OUT
			
			inC[OUT]--;
			TOTC--;
			
			if (sospP[OUT] > 0)
				codaP[OUT].signal();
			if (sospNP[OUT] > 0)
				codaNP[OUT].signal();
			// signal a processi in dir IN
			if (sospP[IN] > 0 && inC[OUT] == 0)
				codaP[IN].signalAll();
			if (sospNP[IN] > 0 && inC[OUT] == 0)
				codaNP[IN].signalAll();
			// verifica
			System.out.println("Non Prenotato esce dal corridoio in dir  OUT");
			stampa_stato();
			
		}

		lock.unlock();

	}

	private void stampa_stato() {
		System.out.println("inC[IN]=" + inC[IN] + "; inC[OUT]=" + inC[OUT] + "; TOTC=" + TOTC + "; LiberiOP=" + LiberiOP+"; liberiON="+LiberiON+"; TOT_JJ="+TOT_JJ);
		System.out.println("sospP[IN]=" + sospP[IN] + "; sospP[OUT]=" + sospP[OUT] + "; sospNP[IN]=" + sospNP[IN]
				+ "; sospNP[OUT]=" + sospNP[OUT] + "\n\n");
	}
}