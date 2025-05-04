package classes;

import java.time.LocalTime;

import javax.servlet.http.HttpSession;

public class Richiesta {
	private HttpSession utente;
	private LocalTime orarioRichiesta;
	
	public Richiesta(HttpSession utente, LocalTime orarioRichiesta) {
		super();
		this.utente = utente;
		this.orarioRichiesta = orarioRichiesta;
	}

	public HttpSession getUtente() {
		return utente;
	}

	public LocalTime getOrarioRichiesta() {
		return orarioRichiesta;
	}

	@Override
	public String toString() {
		return "[sessione=" + utente.getId() + ", orarioRichiesta=" + orarioRichiesta
				+ "]\n";
	}
	
	
	
}
