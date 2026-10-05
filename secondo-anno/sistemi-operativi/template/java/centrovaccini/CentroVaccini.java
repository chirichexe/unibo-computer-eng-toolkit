/*
 * Nome Cognome - Matricola 0000000000
 *
 * Sistemi Operativi T - A.A. 2023-2024
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.util.Random;

public class CentroVaccini {

	private final static int MAX_C = 8; // capacità corridoio
	private  final static int N_P = 4; // operatori per prenotati
	private  final static int N_OD = 4; //operatori per open day
	private  final static int TOT_JJ = 25; //dosi totali J&J
	private final static int U_Prenotati = 30; //utenti prenotati
	private final static int U_OpenDay = 35; //utenti open day
	
	public static void main(String[] args) {
		Random R=new Random(System.currentTimeMillis());
		
		Monitor M = new Monitor(MAX_C, TOT_JJ, N_P, N_OD);
		Prenotato [] UP = new Prenotato[U_Prenotati];
		NonPrenotato [] UOD = new NonPrenotato[U_OpenDay];
		
		for (int i = 0; i <U_Prenotati; i++)
		{	
			UP[i] = new Prenotato(M,R);
		}
		
		for ( int i = 0; i < U_OpenDay; i++)
		{	
			UOD[i] = new NonPrenotato(M,R);
		}
	
		System.out.println("APERTURA HUB :ci sono "+U_Prenotati+" utenti prenotati , e "+U_OpenDay+ " utenti non prenotati per " + TOT_JJ +" dosi di J&J\n\n");

		
		for (int i = 0; i < U_Prenotati; i++)
			UP[i].start();
		
		for ( int i = 0; i < U_OpenDay; i++)
			UOD[i].start();
		
		}
}
