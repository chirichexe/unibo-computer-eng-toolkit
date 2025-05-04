package beans;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.Random;

public class Dati {
	
	List<Giocatore> tab1 = new ArrayList<>();
	List<Giocatore> tab2 = new ArrayList<>();
	List<Giocatore> tab3 = new ArrayList<>();
	List<Giocatore> tab4 = new ArrayList<>();


	public Dati(){
		
		/*---------------------------------------
		 * Database
		 --------------------------------------*/
		Random random = new Random();
		
		System.out.println("Istanzio il database...");
		for ( int i = 0; i < 4 ; i++ ) {
			for ( int j = 0; j < 32 ; j++ ) {
				Giocatore giocatore = new Giocatore("Musetti" + i + j, i, "Ancora nessuno", random.nextInt(1, 6), random.nextInt(1, 6));
				if (i == 0) {
					tab1.add(giocatore);
				} else if (i == 1) {
					tab2.add(giocatore);
				} else if (i == 2) {
					tab3.add(giocatore);
				}else {
					tab4.add(giocatore);
				}
			}
		}
	}
	
	public Optional<List<Giocatore>> getGiocatoriByOne(String surname){
		for ( int i = 0; i < 4 ; i++ ) {
			for ( int j = 0; j < 32 ; j++ ) {
				if (i == 0) {
					if (tab1.get(j).getCognome().equals(surname)) {
						System.out.println("Cognome "+ surname + " trovato nella lista 1");
						return Optional.of(tab1);
					}
				} else if (i == 1) {
					if (tab1.get(j).getCognome().equals(surname)) {
						System.out.println("Cognome "+ surname + " trovato nella lista 2");
						return Optional.of(tab2);
					}
				} else if (i == 2) {
					if (tab1.get(j).getCognome().equals(surname)) {
						System.out.println("Cognome "+ surname + " trovato nella lista 3");
						return Optional.of(tab3);
					}
				}else {
					if (tab1.get(j).getCognome().equals(surname)) {
						System.out.println("Cognome "+ surname + " trovato nella lista 4");
						return Optional.of(tab4);
					}
				}
			}
		}
		
		return Optional.empty();
	}

	@Override
	public String toString() {
		return "Dati [tab1=" + tab1 + ", tab2=" + tab2 + ", tab3=" + tab3 + ", tab4=" + tab4 + "]";
	}
	
	
	
}
