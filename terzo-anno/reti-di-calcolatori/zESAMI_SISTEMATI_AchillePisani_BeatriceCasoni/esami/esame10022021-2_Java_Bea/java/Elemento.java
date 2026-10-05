/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

public class Elemento {
	
	
    private String id;
    private String data;
    private int giorni;
    private String modello;
    private int costoG;
    private String nomeFileFoto;

    // Costruttore
    public Elemento() {
        this.id = "L";
        this.data = "-1/-1/-1";
        this.giorni = -1;
        this.modello = "-1";
        this.costoG = -1;
        this.nomeFileFoto = "L";
    }

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public int getGiorni() {
		return giorni;
	}

	public void setGiorni(int giorni) {
		this.giorni = giorni;
	}

	public String getModello() {
		return modello;
	}

	public void setModello(String modello) {
		this.modello = modello;
	}

	public int getCostoG() {
		return costoG;
	}

	public void setCostoG(int costoG) {
		this.costoG = costoG;
	}

	public String getNomeFileFoto() {
		return nomeFileFoto;
	}

	public void setNomeFileFoto(String nomeFileFoto) {
		this.nomeFileFoto = nomeFileFoto;
	}

    // Getter e Setter
   
}

