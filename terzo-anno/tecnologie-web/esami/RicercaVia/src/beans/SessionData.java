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

public class SessionData {
	private List<Long> duration;
	private int numCompletate;
	
	public SessionData() {
		super();
		this.duration = new ArrayList<>();
		this.numCompletate = 0;
	}

	public String getDuration() {
		return duration.toString();
	}

	public void addDuration(long duration) {
		this.duration.add(duration);
	}


	public int getNumCompletate() {
		return numCompletate;
	}

	public void addCompletate() {
		this.numCompletate++;
	}
	
	@Override
	public String toString() {
		return "[durata=" + duration + ", numCompletate=" + numCompletate + "]";
	}
}
