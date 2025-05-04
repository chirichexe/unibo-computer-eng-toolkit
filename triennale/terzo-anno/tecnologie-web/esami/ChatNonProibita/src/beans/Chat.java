package beans;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.websocket.Session;

public class Chat {
	private List<String> messaggi;
	private List<Session> utenti;
	private boolean isActive;
	
	public Chat() {
		this.messaggi = new ArrayList<>();
		this.utenti = new ArrayList<>();
		this.isActive = false;
	}
	
	public void utenteConnesso(Session s) {
		
		System.out.println("Entra in chat l'utente " + s.getId() );
		if (utenti.size() >= 2 && !isActive ) {
			System.out.println("La chat è ora attiva");
			this.isActive = true;
		}
		this.utenti.add(s);
	}
	
	public boolean inviaMessaggio( String m, Session session ) {
		if ( m.startsWith("A") || m.startsWith("S") ) {
			System.out.println("Qualcuno ha provato a mandare un messaggio proibito");
			return false;
		} else {
			String formattedMessage = session.getId() + " alle " + LocalTime.now().toString() + ": " + m;
			messaggi.add(formattedMessage);
			return true;
		}
	}
	

	public List<String> getMessaggi() {
		return messaggi;
	}



	public List<Session> getUtenti() {
		return utenti;
	}


	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}
	
	@Override
	public String toString() {
		String res = "";
		
		for (String mex : messaggi) {
			res += "<li>" + mex + "</li>";
		}
		
		return res;
	}
	
	
	
}
