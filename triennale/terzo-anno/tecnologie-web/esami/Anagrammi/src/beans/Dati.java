package beans;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import classes.Utente;

public class Dati {

	private List<Utente> utenti;

	public Dati(){
		
		/*---------------------------------------
		 * Database
		 --------------------------------------*/
		System.out.println("Istanzio il database...");
		
		// Utenti "ordinari" mock
		this.utenti = new ArrayList<>();
		
		Utente a1 = new Utente("a1", "1"); 
		Utente a2 = new Utente("a2", "2"); 
		utenti.add(a1);
		utenti.add(a2);
	
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
