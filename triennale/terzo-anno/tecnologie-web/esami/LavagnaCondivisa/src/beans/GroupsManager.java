package beans;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class GroupsManager {
    private static final int MAX_USERS_PER_GROUP = 50;
    private static final int SPLIT_GROUP_SIZE = 25;

    // Liste per i gruppi
    private final List<Utente> group1;
    private final List<Utente> group2;
    
    // Stringhe condivise
    private final StringBuilder group1Lavagna;
    private final StringBuilder group2Lavagna;
    
    // Boolean per settare se è editabile o meno
    private Optional<Utente> utenteEditing;

    public GroupsManager() {
        this.group1 = new ArrayList<>();
        this.group2 = new ArrayList<>();
        this.group1Lavagna = new StringBuilder();
        this.group2Lavagna = new StringBuilder();
        this.utenteEditing = Optional.empty();
        
        System.out.println("Istanzio la classe GroupManager...");
        
    }
    
    public Optional<Utente> getUtenteEditing() {
    	return utenteEditing;
    }
    
    public boolean isFree() {
    	return utenteEditing.isEmpty();
    }
    
    public void setIsEditing(Utente u) {
    	System.out.println("La lavagna è in modifica da parte di: " + u );
    	this.utenteEditing = Optional.of(u);
    }
    
    public void setIsNotEditing() {
    	System.out.println("La lavagna è libera!" );
    	this.utenteEditing = Optional.empty();
    }

    // Aggiunge un utente al gruppo appropriato
    public synchronized void addUser(Utente utente) {
    	// Tento l'aggunta al gruppo 1
    	
    	group1.add(utente);
    	utente.setGroup(1);
    	
        if (group1.size() >= MAX_USERS_PER_GROUP && group2.isEmpty()) {
            // Dividi il gruppo 1 in due gruppi da 25
        	System.out.println("Divido i gruppi...");
            splitGroups();
        }
    }

    // Dividi il gruppo 1 in due gruppi da 25
    private synchronized void splitGroups() {
        // Prendi i primi N utenti per il gruppo 1 e i restanti per il gruppo 2
        List<Utente> newGroup1 = new ArrayList<>(group1.subList(0, SPLIT_GROUP_SIZE));
        List<Utente> newGroup2 = new ArrayList<>(group1.subList(SPLIT_GROUP_SIZE, group1.size()));

        group1.clear();
        group1.addAll(newGroup1);

        group2.clear();
        group2.addAll(newGroup2);
        for (Utente utente : newGroup2) {
			utente.setGroup(2);
		}

        // Copia la stringa del gruppo 1 nel gruppo 2
        System.out.println("Gruppi divisi. Gruppo 2 inizializzato con valore di partenza: " + group1Lavagna);
        group2Lavagna.append(group1Lavagna);
    }

    // Aggiunge testo alla stringa condivisa del gruppo dell'utente
    public synchronized void appendText(Utente utente, String text) {
    	System.out.println("L'utente " + utente + " inserisce sulla lavagna: " + text);
        if (utente.getGroup() == 1) {
            group1Lavagna.append(text).append("\n");
        } else if (utente.getGroup() == 2) {
            group2Lavagna.append(text).append("\n");
        }
    }

    // Ottiene la stringa condivisa per il gruppo dell'utente
    public synchronized String getLavagna(Utente utente) {
        return utente.getGroup() == 1 ? group1Lavagna.toString() : group2Lavagna.toString();
    }

    // Restituisce lo stato corrente dei gruppi
    public synchronized String getGroupsStatus() {
        return String.format(
            "Gruppo 1: %d utenti\nGruppo 2: %d utenti\n",
            group1.size(), group2.size()
        );
    }
}
