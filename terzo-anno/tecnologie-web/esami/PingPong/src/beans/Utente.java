/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package beans;


public class Utente {

	private String username;
	private String password;
	private boolean isPrenotato = false;

	public Utente(String username, String password, boolean isPrenotato){
		this.username =  username;
		this.password = password;
		this.isPrenotato = isPrenotato;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public boolean isPrenotato() {
		return this.isPrenotato;
	}
	
	public void setIsPrenotato(boolean prenotato) {
		this.isPrenotato = prenotato;
	}
	
	

}
