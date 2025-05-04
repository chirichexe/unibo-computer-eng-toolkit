package classes;

public class Utente {

	private String username;
	private String password;
	private int userType = 1;
	private int numRichiesteAdmin = 0;
	// 1= utente, 2=admin

	public Utente(String username, String password){
		this.username =  username;
		this.password = password;
	}
	
	// ==========================
	// ===== SEZIONE ACCESSO ====
	// ==========================

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}
	
	// ==========================
	// === SEZIONE RIRCHESTE ====
	// ==========================

	public void addRichiestaAdmin() {
		this.numRichiesteAdmin ++;
	}
	
	public int getRichiesteAdmin() {
		return this.numRichiesteAdmin;
	}
	
	// ==========================
	// ===== SEZIONE TIPI =======
	// ==========================
	
	public void setIsAdmin() {
		this.userType = 2;
	}
	
	public boolean isAdmin() {
		return this.userType == 2;
	}
	
	// ==========================
	// ======= TOSTRING =========
	// ==========================

	@Override
	public String toString() {
		return "utente " + username 
				+ ", tipologia: " + userType;
	}
}
