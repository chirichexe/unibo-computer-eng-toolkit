/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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
