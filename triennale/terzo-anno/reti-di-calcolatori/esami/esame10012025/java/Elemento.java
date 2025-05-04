//CHIRICHELLA DAVIDE 0001071414

public class Elemento {
    private String matricola = null;
    private String directory = null;

    // Costruttore
    public Elemento() {
        this.matricola = "L";
        this.directory = "L";
    }

    // Getter e Setter
    public String getMatricola() {
        return matricola;
    }

    public synchronized void setMatricola(String matricola) {
        this.matricola = matricola;
    }

    public String getDirectory() {
        return directory;
    }

    public synchronized void setDirectory(String directory) {
        this.directory = directory;
    }

    // Altri metodi utili per la struttura
    public synchronized void libera() {
        matricola = "L";
        directory = "L";
    }

    public boolean isLibera() {
        return (matricola.equals("L") || directory.equals("L"));
    }

    @Override
    public String toString() {
        return "[" + matricola + " - " + directory + "]\t";
    }
}
