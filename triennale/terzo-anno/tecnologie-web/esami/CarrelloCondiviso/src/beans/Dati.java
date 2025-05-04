package beans;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

public class Dati {

	private List<Utente> utenti;
	
	private final static int MAX_GROUP=2;
	private static List<Utente> gruppo1 = new ArrayList<>();
	private static List<Utente> gruppo2 = new ArrayList<>();
	

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
	
	// Divisione static in gruppi
	public static void addUserToGroup(Utente user, int numSessioni) {
		System.out.println("Dimensione gruppo1: " + gruppo1.size());
		if (numSessioni < MAX_GROUP ) {
			System.out.println("Aggiungo al gruppo1 ..." + gruppo1.size());
			gruppo1.add(user);
		} else {
			System.out.println("Aggiungo al gruppo1 ma..." + gruppo1.size());
			gruppo1.add(user);
			gruppo2 = gruppo1.subList(MAX_GROUP/2, MAX_GROUP);
			
			for (Utente utente : gruppo2) {
				utente.setGroup(2);
				
	            // Sincronizza carrello2 con carrello1
	            Carrello carrello = new Carrello();
	            if (carrello != null) {
	                carrello.setCarrello2(carrello.getCarrello1());
	                System.out.println("Aggiornato carrello2 per l'utente: " + utente.getUsername());
	            }
			}
			
			gruppo1 = gruppo1.subList(0, MAX_GROUP/2);
			
			System.out.println("Divido i gruppi...");
			System.out.println("gruppo1: " + gruppo1.toString());
			System.out.println("gruppo2: " + gruppo2.toString());
		}
	}
	
}
