package beans;


public class Utente {

	private String username;
	private String password;
	private int userGroup = 1;
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
	
	// Getter e setter per il "tipo" utente
	public int getGroup() {
		return this.userGroup;
	}
	
	public void setGroup(int groupId) {
		this.userGroup = groupId;
	}
	

	@Override
	public String toString() {
		return "utente " + username + ", gruppo: " + userGroup;
	}

}
