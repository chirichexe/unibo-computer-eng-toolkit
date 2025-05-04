package beans;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public class Tavolo {
	private Map<HttpSession, List<Drink>> tavolo;
	private String idTavolo;
	private boolean isAttivo;
	private float prezzoTavolo;
	
	public Tavolo(String idTavolo) {
		super();
		this.tavolo = new HashMap<>();
		this.idTavolo = idTavolo;
		this.isAttivo = true;
		this.prezzoTavolo = 0.0f;
	}
	
	public Map<HttpSession, List<Drink>> getTavolo() {
		return tavolo;
	}
	public void setTavolo(Map<HttpSession, List<Drink>> tavolo) {
		this.tavolo = tavolo;
	}
	public String getIdTavolo() {
		return idTavolo;
	}
	public void setIdTavolo(String idTavolo) {
		this.idTavolo = idTavolo;
	}
	
	public boolean addDrink( Drink drink, HttpSession user ) {
		if (isAttivo) {
			System.out.println( drink.toString() + " aggiunto al tavolo di " + user.getId());
			this.prezzoTavolo += drink.getPrezzo();
			tavolo.get(user).add(drink);
			return true;
		} else {
			System.out.println("Il tavolo è inattivo");
			return false;
		}
	}
	
	public float getPrezzo() {
		return this.prezzoTavolo;
	}
	
	public float getPrezzo(HttpSession utente) {
		float result = 0.0f;
		for (Map.Entry<HttpSession, List<Drink>> entry : tavolo.entrySet()) {
			HttpSession key = entry.getKey();
			if (key.equals(utente)) {
				List<Drink> val = entry.getValue();
				for (Drink drink : val) {
					result += drink.getPrezzo();
				}
			}
			
		}
		return result;
	}
	
	public void invalida() {
		this.isAttivo = false;
		if (this.prezzoTavolo <= 100.0f) {
			this.prezzoTavolo = 100.0f;
		}
	}
	

	@Override
	public String toString() {
		String res = "Tavolo " + idTavolo + ": ";
		for (Map.Entry<HttpSession, List<Drink>> entry : this.tavolo.entrySet()) {
			List<Drink> val = entry.getValue();
			res += val.toString();
		}
		return res ;
	}
}
