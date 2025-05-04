package classes;


public class Utente {

	private String username;
	private String password;

	public Utente(String username, String password){
		this.username =  username;
		this.password = password;
	}
	
	// Metodi per username e password
	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}
	
	@Override
	public String toString() {
		return "admin " + username ;
	}
}
