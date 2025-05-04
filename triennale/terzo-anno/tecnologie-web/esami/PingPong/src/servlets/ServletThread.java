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
