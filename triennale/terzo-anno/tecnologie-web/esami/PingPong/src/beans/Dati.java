package beans;


import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpSession;

public class Dati {

	private Map<String, Utente> utenti;
	
	private List<Sfida> tavolo1;   
	private List<Sfida> tavolo2;

	public Dati(){
	
		this.utenti = new HashMap<>();
		tavolo1 = new ArrayList<>();
		tavolo2 = new ArrayList<>();

		// registra utenti mock
		utenti.put( "user1" , new Utente("user1", "1", false) );
		utenti.put( "user2" , new Utente("user2", "2", false) );
		utenti.put( "user3" , new Utente("user3", "3", false) );
	}
	
	public Optional<Utente> getUtente(String username, String password) {
	    Utente utente = utenti.get(username);
	    if (utente != null && utente.getPassword().equals(password)) {
	        return Optional.of(utente);
	    }
	    return Optional.empty();
	}
	
	public Optional<Utente> getUtenteByName(String username, String password) {
	    Utente utente = utenti.get(username);
	    if (utente != null && utente.getPassword().equals(password)) {
	        return Optional.of(utente);
	    }
	    return Optional.empty();
	}
	
	public void avviaPingPong() {
		new Thread(() -> {
			while (true) {
				LocalTime now = LocalTime.now();
				
				
			}
		}).start();;
	}
	
	public void iniziaSfida(Utente u, LocalDateTime start) {
		Sfida sfida = new Sfida( start, u);
		if (tavolo1.toArray().length > 5) {
			sfida.setIdTavolo(2);
			tavolo2.add(sfida);
			
		} else {
			tavolo1.add(sfida);
		}
		try {
			Thread.sleep(5 *60*1000);
			if (sfida.secondoGiocatorePresente()) {
				sfida.invalida();
				tavolo1.remove(sfida);
				System.out.println("Sfida " + sfida.toString() + " annullata per mancanza del secondo membro");
			} else {
				
			}
			
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
	}
	
	public String leggi() {
		String res = "";
		for (Sfida sfida : tavolo1) {
			//if (sfida.isValida()) {
				res += "," + sfida.toString();
			//}
		}
		return res;
	}



}
