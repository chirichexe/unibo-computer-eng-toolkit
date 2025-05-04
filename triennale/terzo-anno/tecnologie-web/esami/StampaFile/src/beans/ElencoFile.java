package beans;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class ElencoFile {
	private Map<String, Integer> file;
	
	private int pagStampateDottorandi = 0;
	private int pagStampateProfessori = 0;
	
	private int maxPagDottorandi = 3;
	private int maxPagProfessori = 4;

	
	public ElencoFile() {
		super();
		this.file = new HashMap<String, Integer>();
		
		file.put("file1", 100);
		file.put("file2", 200);
		file.put("file3", 300);
		file.put("file4", 400);
		file.put("file5", 1600);
		
		System.out.println("Avviato elenco file...");
		
	}
	
	public Optional<Integer> getDimFile(String nome) {
		System.out.println("Javabean: ricerco " + nome);
		if (!file.containsKey(nome))
			return Optional.empty();
		else {
			return Optional.of(file.get(nome));
		}
	}
	
	public boolean aggiungiByteStampati(int userType, int numPagine) {
		if (userType == 1) {
			if (maxPagDottorandi - numPagine < 0) {
				System.out.println(maxPagDottorandi + "- " + numPagine);
				return false;
			} 
			pagStampateDottorandi += numPagine;
			System.out.println("Numero pagine dottorandi aggiornate a: " + pagStampateDottorandi );
			return true;
			
		} else {
			if (maxPagProfessori - numPagine < 0) {
				System.out.println(maxPagProfessori + "- " + numPagine);
				return false;
			} 
			pagStampateProfessori += numPagine;
			System.out.println("Numero pagine professori aggiornate a: " + pagStampateProfessori );
			return true;
		}
	}
	
	public int getMaxPagineDottorandi() {
		return maxPagDottorandi;
	}
	
	public int getMaxPagineProfessori() {
		return maxPagProfessori;
	}
	
	public void setMaxPagineProfessori(int num) {
		System.out.println("Settati il num pagine prof" + num);
		this.maxPagProfessori = num;
	}
	
	public void setMaxPagineDottorandi(int num) {
		System.out.println("Settati il num pagine dottorandi" + num);
		this.maxPagDottorandi = num;
	}
	
}
