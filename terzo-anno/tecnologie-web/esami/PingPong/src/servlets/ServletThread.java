/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package servlets;

public class ServletThread extends Thread {
    private int XXXIndex;
    private String XXXString;

    public ServletThread(int XXXIndex, String XXXString) {
        super();
        this.XXXIndex = XXXIndex; // Correzione assegnazione al campo
        this.XXXString = XXXString;
    }

    @Override
    public void run() {
        System.out.println("Thread avviato: XXXIndex = " + XXXIndex + ", XXXString = " + XXXString);
    }
}
