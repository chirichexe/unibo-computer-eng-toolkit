package beans;

public class Utente {

	private String username;
	private String password;
	private int userType = 1;
	private int groupId = 1;
	// 1= utente, 2=admin, 3= XXX

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
	
	// Getter e setter del gruppo
	public void setGroup(int groupId) {
		this.groupId = groupId;
	}
	
	public int getGroup() {
		return this.groupId;
	}
	
	// Getter e setter per il "tipo" utente
	public void setIsAdmin() {
		this.userType = 2;
	}
	
	public void setIsXXX() {
		this.userType = 3;
	}
	
	public boolean isAdmin() {
		return this.userType == 2;
	}
	
	public boolean isXXX() {
		return this.userType == 3;
	}

	@Override
	public String toString() {
		return "utente " + username 
				+ ", tipologia: " + userType 
				+ " - Gruppo: "+ groupId;
	}
	
	
	

}
