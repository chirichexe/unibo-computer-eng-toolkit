/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package beans;

public class TestoContenuto {
	String testoMaiuscolo;
	int numOccorrenze;
	
	public TestoContenuto(String testoMaiuscolo, int numOccorrenze) {
		super();
		this.testoMaiuscolo = testoMaiuscolo;
		this.numOccorrenze = numOccorrenze;
	}
	public String getTestoMaiuscolo() {
		return testoMaiuscolo;
	}
	public void setTestoMaiuscolo(String testoMaiuscolo) {
		this.testoMaiuscolo = testoMaiuscolo;
	}
	public int getNumOccorrenze() {
		return numOccorrenze;
	}
	public void setNumOccorrenze(int numOccorrenze) {
		this.numOccorrenze = numOccorrenze;
	}
	
}
