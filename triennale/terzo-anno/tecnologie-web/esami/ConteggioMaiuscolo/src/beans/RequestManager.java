package beans;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class RequestManager {
	
	private List<LocalTime> orariRichieste = new ArrayList<>();
	int numRichiesteAdmin = 0;
	
	public RequestManager () {
		System.out.println("Istanzio il gestore del numero di richieste...");
	}
	
	
	public void aggiungiRichiestaAdmin() {
		System.out.println("Un admin fa la richiesta");
		numRichiesteAdmin ++ ;
	}
	
	public void aggiungiRichiestaUser() {
		LocalTime now = LocalTime.now();
		System.out.println("Un user fa la richiesta alle:  " + now);
		
		for (LocalTime orarioRichiesta : orariRichieste) {
			if ( orarioRichiesta.plusSeconds(20).isAfter(now) ) {
				System.out.println("Rimuovo una richiesta...");
				orariRichieste.remove(orarioRichiesta);
			}
		}
		
		orariRichieste.add(now);
	}
	
	@Override
	public String toString() {
		return "Numero richieste utenti: " + this.orariRichieste.size() 
			 + "\nNumero richieste admin: " + this.numRichiesteAdmin; 
	}
}
