/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package classes;

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
	// ===== SEZIONE GRUPPI =====
	// ==========================

	public void setGroup(int groupId) {
		this.groupId = groupId;
	}
	
	public int getGroup() {
		return this.groupId;
	}
	
	// ==========================
	// ===== SEZIONE TIPI =======
	// ==========================
	
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
	
	// ==========================
	// ======= TOSTRING =========
	// ==========================

	@Override
	public String toString() {
		return "utente " + username 
				+ ", tipologia: " + userType 
				+ " - Gruppo: "+ groupId;
	}
	
	
	

}
