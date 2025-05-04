package beans;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

public class ArticoliManager {
	
    private Map<Articolo, Optional<HttpSession>> articoliMap;

    public ArticoliManager() {
    	
        this.articoliMap = new HashMap<>();
        System.out.println("Istanzio la classe ArticoliManager...");
        
    }

    // Aggiunge un utente al gruppo appropriato
    public synchronized void addArticolo(String nome, HttpSession session) {
    	Optional<Articolo> articolo = getArticoloByName(nome);
    	if (!articolo.isEmpty()) {
    		System.out.println("Ora la sessione " + session.getId() + " è associata all'articolo " + nome);
    		articoliMap.put(articolo.get(), Optional.of(session));
    	} else {
    		System.out.println("La nuova sessione " + session.getId() + " ha creato l'articolo " + nome);
    		articoliMap.put(new Articolo(nome), Optional.empty() );
    	}
    	
    }
    
    public Optional<Articolo> getArticoloByName(String name) {
    	for (Map.Entry<Articolo, Optional<HttpSession>> entry : articoliMap.entrySet()) {
    		Articolo key = entry.getKey();
			if (key.getNome().equals(name))
				return Optional.of(key);
		}
    	return Optional.empty();
    }
    
    public synchronized boolean richiediModifica(String name) {
    	System.out.println("Richiesta modifica per l'articolo: " +name);
    	Articolo articolo = getArticoloByName(name).get();
    	if (articolo.isLibero()) {
    		articolo.setLibero(false);
    		return true;
    	} else {
    		return false;
    	}
    }
    
    public synchronized void rilasciaRichiestaModifica(String name) {
    	System.out.println("L'articolo ora è libero: " + name);
    	Articolo articolo = getArticoloByName(name).get();
    		articolo.setLibero(true);
    }

    // Aggiunge testo alla stringa condivisa del gruppo dell'utente
    public void appendText(String name, String nuovoContenuto) {
    	Optional<Articolo> articolo = getArticoloByName(name);
    	articolo.get().setContenuto(nuovoContenuto);
    }


}
