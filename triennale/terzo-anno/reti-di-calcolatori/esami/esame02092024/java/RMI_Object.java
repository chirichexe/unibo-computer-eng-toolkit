//CHIRICHELLA DAVIDE 0001071414

import java.io.*;

public class RMI_Object implements Serializable {
    
    private String DATO1 = null;
    private String DATO2 = null;
    private int DATO3;

    // Costruttore
    public RMI_Object() {
        this.DATO1 = "L";
        this.DATO2 = "L";
        this.DATO3 = -1;
    }

    // Getter e Setter
    public String getDATO1() {
        return DATO1;
    }

    public synchronized void setDATO1(String DATO1) {
        this.DATO1 = DATO1;
    }

    public String getDATO2() {
        return DATO2;
    }

    public synchronized void setDATO2(String DATO2) {
        this.DATO2 = DATO2;
    }

    public int getDATO3() {
        return DATO3;
    }

    public synchronized void setDATO3(int DATO3) {
        this.DATO3 = DATO3;
    }

    // Altri metodi utili per la struttura;
    public synchronized void libera(){
        DATO1 = "L";
        DATO2 = "L";
        DATO3 = -1;
    }

    @Override
    public String toString() {
        return DATO1 + "\t" + DATO2 + "\t" + DATO3;
    }
}