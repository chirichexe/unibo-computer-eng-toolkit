
import java.io.*;

public class Esame implements Serializable {
    public String tabella[][] = new String[50][4];

    public Esame() {
        for (int i = 0; i < 50; i++)
            for (int e = 0; e < 4; e++)
                tabella[i][e] = "-";
    }

    public synchronized int iscrivi_studente_appello(String matricola, String nome, String cognome) {
        System.out.println("Programma: iscrizione di " + nome);

        for (int k = 0; k < 50; k++) {
            if (tabella[k][0] == "-") {
                tabella[k][0] = matricola;
                tabella[k][1] = nome;
                tabella[k][2] = cognome;

                return 0;
            }
        }
        return -1;
    }

    public synchronized String[] carica_voti(String input) {
        System.out.println("Programma: caricamento voti: " + input);

        String[] senzaSuccesso = new String[50];
        int numSenzaSuc = 0;

        String[] subStrings = input.split(":");
        for (int i = 0; i < subStrings.length; i++){
            String[] tupla = subStrings[i].split(",");
            boolean trovato = false;
            for (int k = 0; k < 50; k++) {
                if (tabella[k][0].equals(tupla[0])){
                    tabella[k][3] = tupla[1];
                    trovato = true;
                    break;
                }
                
            }

            if (!trovato){
                senzaSuccesso[numSenzaSuc] = tupla[0];
                numSenzaSuc++;
            }

            
        }
        
        return senzaSuccesso;
    }

    public void stampa() {

        System.out.println("\tMATRICOLA\tNOME\tCOGNOME\tVOTO\n");
        for (int k = 0; k < 50; k++) {
            String line = new String((k + 1) + "|");
            for (int j = 0; j < 4; j++) {
                line += "\t" + tabella[k][j];
            }
            line += "\n";
            System.out.println(line);
        }
    }
}