package beans;

import java.util.Objects;

public class Utente {

	private String username;
	private String password;
	private int groupId = 1;

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
	
	@Override
	public String toString() {
		return "utente " + username 
				+ " - Gruppo: "+ groupId;
	}


	@Override
	public boolean equals(Object obj) {
		System.out.println("Invoco il metodo equals");
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Utente other = (Utente) obj;
		return groupId == other.groupId && Objects.equals(password, other.password)
				&& Objects.equals(username, other.username);
	}
	
	
	

}
