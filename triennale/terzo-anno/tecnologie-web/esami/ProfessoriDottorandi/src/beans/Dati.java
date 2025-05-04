package beans;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Dati {
	
	// Database Utenti
    private List<Utente> utenti;
    
    //Gruppi

    public Dati() {

        /*---------------------------------------
         * Database
         --------------------------------------*/
    	
    	System.out.println("Istanzio la classe dati...");

        // Utenti "ordinari" mock
        this.utenti = new ArrayList<>();

        Utente u1 = new Utente("dot1", "1");
        Utente u2 = new Utente("dot2", "2");
        utenti.add(u1);
        utenti.add(u2);

        // Utente admin
        Utente a1 = new Utente("a", "1");
        a1.setIsAdmin();
        utenti.add(a1);

        // Utente Professore
        Utente aProfessore = new Utente("prof", "1");
        aProfessore.setIsProfessore();
        utenti.add(aProfessore);

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
