package beans;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

public class Bar {
    // Liste per i gruppi
    private final List<Tavolo> tavoli;
    private final List<Drink> drinks;

    public Bar() {
        this.tavoli = new ArrayList<>();
        this.drinks = new ArrayList<>();
        
        drinks.add(new Drink(10.0f, "Gin Tonic" ));
        drinks.add(new Drink(12.0f, "Gin Mare" ));
        drinks.add(new Drink(13.0f, "Gin Lemon" ));
        
        System.out.println("Istanzio la classe del Bar...");
        
    }

    // Aggiunge un utente al gruppo appropriato
    public synchronized void addUserToTavolo(HttpSession user, String idTavolo) {
    	for (Tavolo tavolo : tavoli) {
			if (tavolo.getIdTavolo().equals(idTavolo)) {
				tavolo.getTavolo().put(user, new ArrayList<>() );
		    	System.out.println("Tavolo esistente, lo aggiungo...");
				return;
			}
    	}
    	System.out.println("Tavolo non esistente, lo creo...");
    	Tavolo newTavolo = new Tavolo(idTavolo);
    	newTavolo.getTavolo().put(user, new ArrayList<>());
    	tavoli.add(newTavolo);
    	
    }
    
    public synchronized boolean addDrinkToTavolo(HttpSession user, String nomeDrink, String idTavolo) {
    	for (Drink drink : drinks) {
			if (nomeDrink.equals(drink.getNome())) {
				for (Tavolo tavolo : tavoli) {
					if (tavolo.getIdTavolo().equals(idTavolo)) {
						tavolo.addDrink(drink, user);
						return true;
					}
				}
				return false;
			}
		}
    	return false;
    }
    
    public synchronized float getPrezzoTavolo(String idTavolo) {
		for (Tavolo tavolo : tavoli) {
			if (tavolo.getIdTavolo().equals(idTavolo)) {
				return tavolo.getPrezzo();
			}
		}
		return 0.0f;
	}
    
    public synchronized float getPrezzoTavolo(String idTavolo, HttpSession user) {
		for (Tavolo tavolo : tavoli) {
			if (tavolo.getIdTavolo().equals(idTavolo)) {
				return tavolo.getPrezzo(user);
			}
		}
		return 0.0f;
	}
    
    public synchronized void invalidaTavolo(String idTavolo) {
		for (Tavolo tavolo : tavoli) {
			if (tavolo.getIdTavolo().equals(idTavolo)) {
				tavolo.invalida();
			}
		}
	}
    
    public List<Tavolo> getTavoli() {
		return this.tavoli;
	}
}
