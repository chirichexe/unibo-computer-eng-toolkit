package beans;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Dati {

	private List<Utente> utenti;

	public Dati(){
		
		/*---------------------------------------
		 * Database utenti
		 --------------------------------------*/
		
		// Utenti "ordinari" mock
		this.utenti = new ArrayList<>();
		
		Utente u1 = new Utente("u1", "1"); 
		Utente u2 = new Utente("u2", "2"); 
		utenti.add(u1);
		utenti.add(u2);
		
		// Utente admin 
		Utente a1 = new Utente("a", "1");
		a1.setIsAdmin();
		utenti.add(a1);
		
		// Utenti Professore
		Utente p1 = new Utente("p1", "1");
		p1.setIsProfessore();
		utenti.add(p1);
		
		Utente p2 = new Utente("p2", "1");
		p2.setIsProfessore();
		utenti.add(p2);
	
	}
	
	// Metodi per il "database"
	public Optional<Utente> getUtente(String username, String password) {
	    for (Utente utente : utenti) {
	        if (utente.getUsername().equals(username) && utente.getPassword().equals(password)) {
	            return Optional.of(utente);
	        }
	    }
	    return Optional.empty();
	}
	
	public Optional<Utente> getUtenteByName(String username) {
	    for (Utente utente : utenti) {
	        if (utente.getUsername().equals(username)) {
	            return Optional.of(utente);
	        }
	    }
	    return Optional.empty();
	}
	
}
