/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package beans;

public class Giocatore {
	private String cognome;
	private int rankingATP;
	private String titoliVinti;
	private int numPartiteVinte;
	private int numPartitePerse;
	
	public Giocatore(String cognome, int rankingATP, String titoliVinti, int numPartiteVinte, int numPartitePerse) {
		super();
		this.cognome = cognome;
		this.rankingATP = rankingATP;
		this.titoliVinti = titoliVinti;
		this.numPartiteVinte = numPartiteVinte;
		this.numPartitePerse = numPartitePerse;
	}
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	public int getRankingATP() {
		return rankingATP;
	}
	public void setRankingATP(int rankingATP) {
		this.rankingATP = rankingATP;
	}
	public String getTitoliVinti() {
		return titoliVinti;
	}
	public void setTitoliVinti(String titoliVinti) {
		this.titoliVinti = titoliVinti;
	}
	public int getNumPartiteVinte() {
		return numPartiteVinte;
	}
	public void setNumPartiteVinte(int numPartiteVinte) {
		this.numPartiteVinte = numPartiteVinte;
	}
	public int getNumPartitePerse() {
		return numPartitePerse;
	}
	@Override
	public String toString() {
		return "Giocatore [cognome=" + cognome + "]";
	}
	public void setNumPartitePerse(int numPartitePerse) {
		this.numPartitePerse = numPartitePerse;
	}
}
