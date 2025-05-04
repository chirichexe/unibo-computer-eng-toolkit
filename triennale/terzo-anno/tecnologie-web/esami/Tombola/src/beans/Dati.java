package beans;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import classes.Utente;

public class Dati {
	
	// ==========================
	// ======= DATABASE =========
	// ==========================
	
    private List<Utente> utenti;

    public Dati() {
    	this.utenti = new ArrayList<>();
    	System.out.println("Istanzio la classe dati...");

    	// Utenti ordinari
        Utente u1 = new Utente("u1", "1");
        Utente u2 = new Utente("u2", "2");
        utenti.add(u1);
        utenti.add(u2);

        // Utente admin
        Utente a1 = new Utente("a", "1");
        a1.setIsAdmin();
        utenti.add(a1);

        // Utente XXX
        Utente aXXX = new Utente("XXX", "1");
        aXXX.setIsXXX();
        utenti.add(aXXX);

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
