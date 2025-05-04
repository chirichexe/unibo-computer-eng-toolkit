package beans;

import java.util.ArrayList;
import java.util.List;

import classes.Utente;

public class RequestsManager {
	private int numRichiesteInCorso;
	
    public RequestsManager() {
    	System.out.println("Istanzio il gestore delle richieste...");
        this.numRichiesteInCorso = 0;
    }

    public synchronized void faiRichiesta() {
    	System.out.println("Richiesta cominciata...");	
    	numRichiesteInCorso ++;
    }
    
    public synchronized void terminaRichiesta() {
    	System.out.println("Richiesta terminata...");	
    	numRichiesteInCorso --;
    }
    
    public int getNumRichiesteInCorso() {
    	return this.numRichiesteInCorso;
    }

}
