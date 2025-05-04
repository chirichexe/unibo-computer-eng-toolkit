package beans;

public class Drink {
	private float prezzo;
	private String nome;
	
	public Drink(float prezzo, String nome) {
		super();
		this.prezzo = prezzo;
		this.nome = nome;
	}
	public float getPrezzo() {
		return prezzo;
	}
	public void setPrezzo(float prezzo) {
		this.prezzo = prezzo;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	@Override
	public String toString() {
		return "Drink [prezzo=" + prezzo + ", nome=" + nome + "]";
	}
	
	
	
}
