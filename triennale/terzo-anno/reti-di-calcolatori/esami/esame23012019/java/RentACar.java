import java.io.*;

public class RentACar implements Serializable {
    public String tabella[][] = new String[9][4];

    public RentACar() {
        // Inizializzazione dei dati
        tabella[0] = new String[]{"AN745NL", "00003", "auto", "AN745NL_img/"};
        tabella[1] = new String[]{"FE457GF", "50006", "camper", "FE457GF_img/"};
        tabella[2] = new String[]{"L", "0", "L", "L"};
        tabella[3] = new String[]{"NU547PL", "40063", "auto", "NU547PL_img/"};
        tabella[4] = new String[]{"LR897AH", "56832", "camper", "LR897AH_img/"};
        tabella[5] = new String[]{"MD506DW", "00100", "camper", "MD506DW_img/"};
        tabella[6] = new String[]{"L", "0", "L", "L"};
        tabella[7] = new String[]{"L", "0", "L", "L"};
        tabella[8] = new String[]{"L", "0", "L", "L"};
    }

    public synchronized int elimina_prenotazione(String numTarga){
        System.out.println("Programma: elimina pren. di " + numTarga);

        for (int k = 0; k < tabella.length; k++) {
            if (tabella[k][0].equals(numTarga) ) {
                tabella[k] = new String[]{"L", "0", "L", "L"};
                return 0;
            }
        }

        return -1;
    }

    public synchronized String[][] visualizza_prenotazioni(String tipoVeicolo) {
        System.out.println("Programma: visualizza pren.: " + tipoVeicolo);

        String[][] prenotazioni = new String[9][4];
        int numPren = 0;

        for (int k = 0; k < tabella.length; k++) {
            if (tabella[k][2].equals(tipoVeicolo) ) {
                prenotazioni[numPren][0] = tabella[k][0];
                prenotazioni[numPren][1] = tabella[k][1];
                prenotazioni[numPren][2] = tabella[k][2];
                prenotazioni[numPren][3] = tabella[k][3];
                numPren++;
            }
        }
        
        return prenotazioni;
    }

    public void stampa() {

        System.out.println("\tTARGA\tPATENTE\tAUTO\tCARTELLA FOTO\n");
        for (int k = 0; k < 9; k++) {
            String line = new String((k + 1) + "|");
            for (int j = 0; j < 4; j++) {
                line += "\t" + tabella[k][j];
            }
            line += "\n";
            System.out.println(line);
        }
    }
}