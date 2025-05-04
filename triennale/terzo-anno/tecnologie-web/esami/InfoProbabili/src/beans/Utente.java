package beans;

public class Utente {

	private String username;
	private String password;
	private int userType = 1;
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
	
	// Getter e setter per il "tipo" utente
	public void setIsAdmin() {
		this.userType = 2;
	}
	
	public boolean isAdmin() {
		return this.userType == 2;
	}
	

	@Override
	public String toString() {
		return username;
	}
	
	
	

}
