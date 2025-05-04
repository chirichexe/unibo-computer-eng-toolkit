package beans;

import java.time.LocalDateTime;
import java.util.Optional;

public class Sfida {
	private boolean isValida;
	private int idTavolo = 1;
	private LocalDateTime start;
	private LocalDateTime end;
	private Optional<Utente> partecipante1 ;
	private Optional<Utente> partecipante2;
	
	public Sfida( LocalDateTime start, Utente iniziale) {
		super();
		this.start = start;
		this.end = start.plusMinutes(30);
		this.isValida = false;
		
		System.out.println(iniziale.getUsername() + " inizia la sfida alle " + start.toString() + " - " + end.toString());
		
		iniziale.setIsPrenotato(true);
		this.partecipante1 = Optional.of(iniziale);
	}
	
	public boolean secondoGiocatorePresente() {
		return Optional.of(partecipante2).isEmpty();
	}
	
	public void accettaSfida(Utente secondo) {
		System.out.println(secondo.getUsername() + " accetta la sfida alle " + start.toString() + " - " + end.toString());

		
		secondo.setIsPrenotato(true);
		this.partecipante2 = Optional.of(secondo);
	}
	
	public void invalida() {
		this.isValida = false;
		this.partecipante1.get().setIsPrenotato(false);
		this.partecipante2.get().setIsPrenotato(false);
	}
	
	public void valida() {
		this.isValida = true;
	}
	
	public boolean isValida() {
		return this.isValida;
	}
	
	public int getTavolo() {
		return this.idTavolo;
	}
	
	public void setIdTavolo(int id) {
		this.idTavolo = id;
	}
	
	@Override
	public String toString() {
		return partecipante1.get().getUsername() + " vs. " + partecipante2.get().getUsername() 
				+ ": Inizio" + start.toString() + " Fine: " + end.toString();
	}
	
}
