package beans;

public class Articolo {
	private String nome;
	private String contenuto = "";
	private boolean isLibero = true;
	
	public Articolo(String nome) {
		super();
		this.nome = nome;
	}

	public String getContenuto() {
		return contenuto;
	}
	

	public String getNome() {
		return nome;
	}

	public void setContenuto(String contenuto) {
		this.contenuto += contenuto;
	}

	@Override
	public String toString() {
		return "Articolo [nome=" + nome + ", contenuto=" + contenuto + ", isLibero=" + isLibero + "]";
	}

	public boolean isLibero() {
		return isLibero;
	}

	public void setLibero(boolean isLibero) {
		this.isLibero = isLibero;
	}
	
	
	
	
	
}
