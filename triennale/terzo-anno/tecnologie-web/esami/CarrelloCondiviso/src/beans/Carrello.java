package beans;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Carrello implements Serializable {

    private static final long serialVersionUID = 1L;

    // Attributi istanza
    private boolean presente;
    private Map<String, Integer> carrello1;
    private Map<String, Integer> carrello2;

    // Costruttore vuoto
    public Carrello() {
        this.presente = false;
        this.carrello1 = new HashMap<>();
        
        this.carrello1.put("Zucchine", 0);
		this.carrello1.put("Carote", 0);
		this.carrello1.put("Biscotti", 0);
		this.carrello1.put("Patate", 0);
		this.carrello1.put("Aspirapolvere", 0);
		this.carrello1.put("SBORRA", 0);        
        
        this.carrello2 = new HashMap<>();
    }

    // Getter e Setter
    public boolean isPresente() {
    	System.out.println("Stato presenza: " + presente);
        return presente;
    }

    public void setPresente(boolean presente) {
    	System.out.println("Stato presenza: " + presente);
        this.presente = presente;
    }
    
    // Inizializzato vuoto
    public Map<String, Integer> getCarrello1() {
        return carrello1;
    }

    public Map<String, Integer> getCarrello2() {
        return carrello2;
    }

    public void setCarrello2(Map<String, Integer> carrello2) {
        this.carrello2 = carrello2;
    }
}
