package beans;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import classes.Richiesta;

public class RequestManager {

    // Liste per i gruppi
    private final List<Richiesta> richieste;

    public RequestManager() {
        this.richieste = new ArrayList<>();
        System.out.println("Istanzio la classe RequestManager...");
        
    }
    
    public synchronized void addRichiesta(HttpSession utente) {
    	System.out.println(utente.getId() + " fa una nuova richiesta...");
        this.richieste.add(new Richiesta(utente, LocalTime.now()));
    }
    
    public int getRichieste() {
    	int richiesteUtenti = 0;
    	
    	for (Richiesta richiesta : richieste) {
			if ( richiesta.getOrarioRichiesta().plusMinutes(1).isAfter(LocalTime.now()) ) {
				richiesteUtenti ++;
			}
		}
    	
    	return richiesteUtenti;
    }
    
}
