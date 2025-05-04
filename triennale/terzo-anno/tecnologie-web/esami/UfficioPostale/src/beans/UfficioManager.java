package beans;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import servlets.WebSocket;

public class UfficioManager {
	
	// Parametri
	private final int ATTESA_RINNOVO = 5;
	private final int ATTESA_RESIDENZA = 8;
	
    // Liste per i gruppi
    private final Map<Utente, LocalTime> codaRinnovo;
    private final Map<Utente, LocalTime> codaResidenza;

    public UfficioManager() {
        this.codaRinnovo = new HashMap<>();
        this.codaResidenza = new HashMap<>();
        
        System.out.println("Istanzio la classe per il gestore dell'ufficio...");
        
        // Controlla periodicamente
        new Thread(() -> {
			while(true) {
			    
			    // itero lungo la coda del rinnovo carta
			    for (Map.Entry<Utente, LocalTime> entry : codaRinnovo.entrySet()) {
					Utente key = entry.getKey();
					LocalTime val = entry.getValue();
					if ( LocalTime.now().isAfter(val) ) {
						System.out.println("L'utente " + key + " ha finito");
						codaRinnovo.remove(key);
					}
				}
			    
			    // itero lungo la coda delle residenze
			    for (Map.Entry<Utente, LocalTime> entry : codaResidenza.entrySet()) {
					Utente key = entry.getKey();
					LocalTime val = entry.getValue();
					if ( LocalTime.now().isAfter(val) ) {
						System.out.println("L'utente " + key + " ha finito");
						codaResidenza.remove(key);
					}
				}
			}
        }).start();
        
    }

    // Aggiunge un utente al gruppo appropriato
    public synchronized int addUser(Utente utente, String servizio) {
    	
    	System.out.println("L'utente " + utente + " richiede: " + servizio);
    	int tempoAttesaMillis = -1;
    	LocalTime fine;
    	
    	if (utente.isPrioritario()) {
    		System.out.println("Entra un utente prioritario, ricalcolo...");
    		WebSocket.broadcast("Arrivato un utente prioritario!");
    	}
    	
    	if (servizio.equals("R")) {
    		
    		tempoAttesaMillis = ((codaRinnovo.size() + 1) * ATTESA_RINNOVO) + (codaResidenza.size() + ATTESA_RESIDENZA);
    		fine = LocalTime.now().plusMinutes(tempoAttesaMillis);
    		
    		if (!codaRinnovo.containsKey(utente)) {
    			codaRinnovo.put(utente, fine);    			
    			utente.setGroup(1);
    		}
    		
    	} else if (servizio.equals("C")) {
    		
    		tempoAttesaMillis = (codaRinnovo.size() * ATTESA_RINNOVO) + ((codaResidenza.size() + 1) * ATTESA_RESIDENZA);
    		fine = LocalTime.now().plusMinutes(tempoAttesaMillis);
    		
    		if (!codaResidenza.containsKey(utente)) {
    			codaResidenza.put(utente, fine);    			
    			utente.setGroup(2);
    		}
    	} else {
    		System.err.println("Servizio non trovato");
    	}
    	
    	return tempoAttesaMillis;
    }

    // Restituisce lo stato corrente dei gruppi
    public String getGroupsStatus() {
    	return (codaRinnovo + "\n" + codaResidenza);
    }
}
