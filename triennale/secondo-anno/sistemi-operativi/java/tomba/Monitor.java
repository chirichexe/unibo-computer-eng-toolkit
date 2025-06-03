import java.util.concurrent.locks.*;
// Esercitazione 11.1: per fare terminare il programma, prevedo che una guida possa uscire 
// dalla tomba quando la tomba è vuota

public class Monitor {
	private final int NC=10;
	private final int MAX=15;
	public  final int IN = 0;
	public  final int OUT = 1;

	//variabili di stato per la tomba
	private int totTomba;
	private int guideInTomba;

	//variabili di stato per il corridoio
	private int totCorridoio;
	private int[] singoli = new int[2];
	private int[] passeggini  = new int[2];
	private int[] guide   = new int[2];

	private Lock l = new ReentrantLock();
	private Condition[] codaSingoli = new Condition[2];
	private Condition[] codaPasseggini = new Condition[2];
	private Condition[] codaGuide = new Condition[2];

	private int[] sospS= new int[2];
	private int[] sospP= new int[2];
	private int[] sospG= new int[2];

	public Monitor() {
		totTomba=0;
		guideInTomba=0;
		totCorridoio=0;
		singoli[IN]=0;
		singoli[OUT]=0;
		passeggini[IN]=0;
		passeggini[OUT]=0;
		guide[IN]=0;
		guide[OUT]=0;

		sospS[IN]=0;
		sospS[OUT]=0;
		sospP[IN]=0;
		sospP[OUT]=0;
		sospG[IN]=0;
		sospG[OUT]=0;

		codaSingoli[IN] = l.newCondition(); 
		codaSingoli[OUT] = l.newCondition();
		codaPasseggini[IN] = l.newCondition();
		codaPasseggini[OUT] = l.newCondition();
		codaGuide[IN] = l.newCondition();
		codaGuide[OUT] = l.newCondition();		

	}
	public void entraSingolo (int id, int dir) throws InterruptedException
	{
		l.lock();
		try {
			if (dir==IN) {
				while (totCorridoio==NC || totTomba==MAX || guideInTomba==0 || sospP[OUT]>0 || sospS[OUT]>0 || sospG[OUT]>0 || sospG[IN]>0 || sospP[IN]>0) {
					sospS[IN]++;
					codaSingoli[IN].await();
					sospS[IN]--;
				}
				totCorridoio++;
				singoli[IN]++;
				totTomba++;
				System.out.println("Singolo "+id+" entrato nel corridoio dir=IN.\n"+stato());
			}else { // direzione OUT
				while (totCorridoio==NC || sospP[OUT]>0 ) {
					sospS[OUT]++;
					codaSingoli[OUT].await();
					sospS[OUT]--;
				}
				totCorridoio++;
				singoli[OUT]++;
				totTomba--;
				System.out.println("Singolo "+id+" entrato nel corridoio dir=OUT.\n"+stato());

			}
		} catch (InterruptedException e) {} 
		finally {l.unlock();}

	}

	public void esciSingolo(int id, int dir) 
	{
		l.lock();

		if (dir==IN) {
			totCorridoio--;
			singoli[IN]--;	
			System.out.println("Singolo "+id+" uscito dal corridoio dir=IN.\n"+stato());
		}else { //OUT
			totCorridoio--;
			singoli[OUT]--;
			System.out.println("Singolo "+id+" uscito dal corridoio dir=OUT.\n"+stato());
		}

		// Signal al più prioritario in attesa:

		if(sospP[OUT]>0 ) 
			codaPasseggini[OUT].signal();
		else if (sospS[OUT]>0)
			codaSingoli[OUT].signal();
		else if (sospG[OUT]>0 )
			codaGuide[OUT].signal();
		else if (sospG[IN]>0 )
			codaGuide[IN].signal();
		else if (sospP[IN]>0 ) 
			codaPasseggini[IN].signal();	
		else if (sospS[IN]>0 )
			codaSingoli[IN].signal();
		l.unlock();
	}

	public void entraPasseggino(int id, int dir) throws InterruptedException
	{
		l.lock();
		try {
			if (dir==IN) {
				while (totCorridoio+2>NC || totTomba+2>MAX || guideInTomba==0 || passeggini[OUT]>0 || sospP[OUT]>0 || sospS[OUT]>0 || sospG[OUT]>0 || sospG[IN]>0) {
					sospP[IN]++;
					codaPasseggini[IN].await();
					sospP[IN]--;
				}
				totCorridoio+=2;
				passeggini[IN]++;
				totTomba+=2;
				System.out.println("Passeggino "+id+" entrata nel corridoio dir=IN.\n"+stato());
			}else { //OUT
				while (totCorridoio+2>NC || passeggini[IN]>0) { //massima priorità
					sospP[OUT]++;
					codaPasseggini[OUT].await();
					sospP[OUT]--;
				}
				totCorridoio+=2;
				passeggini[OUT]++;
				totTomba-=2;
				System.out.println("Passeggino "+id+" entrata nel corridoio dir=OUT.\n"+ stato());				
			}
		} catch (InterruptedException e) {} 
		finally {l.unlock();}
	}

	public void esciPasseggino(int id, int dir) 
	{	l.lock();
	if (dir==IN) {
		totCorridoio-=2;
		passeggini[IN]--;	
		System.out.println("Passeggino "+id+" uscita dal corridoio dir=IN.\n"+stato());
	}else //OUT
	{
		totCorridoio-=2;
		passeggini[OUT]--;	
		System.out.println("Passeggino "+id+" uscita dal corridoio dir=OUT.\n"+stato());
	}


	if(sospP[OUT]>0 && passeggini[IN]==0) 
		codaPasseggini[OUT].signalAll();
	if (sospS[OUT]>0)
	{	codaSingoli[OUT].signal();
		codaSingoli[OUT].signal();
	}
	if (sospG[OUT]>0 )
	{	codaGuide[OUT].signal();
		codaGuide[OUT].signal();
	}
	if (sospG[IN]>0 ) {
		codaGuide[IN].signal();
		codaGuide[IN].signal();
	}
	if (sospP[IN]>0 && passeggini[OUT]==0) 
		codaPasseggini[IN].signalAll();	
	if (sospS[IN]>0 ) {
		codaSingoli[IN].signal();
		codaSingoli[IN].signal();
	}
	l.unlock();
	}

	public void entraGuida(int id, int dir) throws InterruptedException
	{	l.lock();
	try {
		if (dir==IN) {
			while (totCorridoio==NC || totTomba==MAX || sospP[OUT]>0 || sospS[OUT]>0 || sospG[OUT]>0) {
				sospG[IN]++;
				codaGuide[IN].await();
				sospG[IN]--;
			}
			totCorridoio++;
			guide[IN]++;
			totTomba++;
			guideInTomba++;
			System.out.println("Guida "+id+" entrata nel corridoio dir=IN.\n"+stato());
		}else { //OUT
			while (totCorridoio==NC || (guideInTomba==1 && totTomba-guideInTomba>0)|| sospP[OUT]>0 || sospS[OUT]>0 ) {
				// spiegazione di && totTomba-guideInTomba>0:
				// per fare terminare il programma, prevedo che una guida possa uscire dalla tomba quando la tomba è vuota
				sospG[OUT]++;
				codaGuide[OUT].await();
				sospG[OUT]--;
			}
			totCorridoio++;
			guide[OUT]++;
			totTomba--;
			guideInTomba--;
			System.out.println("Guida "+id+" entrata nel corridoio dir=OUT.\n"+stato());				
		}
	} catch (InterruptedException e) {} 
	finally {l.unlock();}
	}

	public void esciGuida(int id, int dir) 
	{	l.lock();
	if (dir==IN) {
		totCorridoio--;
		guide[IN]--;	
		System.out.println("Guida "+id+" uscita dal corridoio dir=IN.\n"+stato());
	}else { //OUT
		totCorridoio--;
		guide[OUT]--;
		System.out.println("Guida "+id+" uscita dal corridoio dir=OUT.\n"+stato());
	}

	// Signal al più prioritario in attesa:

	if(sospP[OUT]>0 ) 
		codaPasseggini[OUT].signal();
	else if (sospS[OUT]>0)
		codaSingoli[OUT].signal();
	else if (sospG[OUT]>0 )
		codaGuide[OUT].signal();
	else if (sospG[IN]>0 )
		codaGuide[IN].signal();
	else if (sospP[IN]>0 ) 
		codaPasseggini[IN].signal();	
	else if (sospS[IN]>0 )
		codaSingoli[IN].signal();
	l.unlock();
	}


	public String stato() { //per DEBUG
		return "[totTomba="+totTomba+" guideInTomba="+guideInTomba+" totCorridoio="+totCorridoio
				+ " singoliIN="+singoli[IN]+" passegginiIN="+passeggini[IN]+" guideIN="+guide[IN]
						+ " singoliOUT="+singoli[OUT]+" passegginiOUT="+passeggini[OUT]+" guideOUT="+guide[OUT]
								+ " sospSin="+sospS[IN]+" sospPin="+sospP[IN]+" sospGin="+sospG[IN]
										+ " sospSout="+sospS[OUT]+" sospPout="+sospP[OUT]+" sospGout="+sospG[OUT]+"   ]";
	}


}