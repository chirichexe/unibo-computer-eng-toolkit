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
