/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;

public class RMI_Object implements Serializable {
    
    public String id = null;
    public String data = null;
    public int giorni = -1;
    public String modello = null;
    public int costoGiorn = -1;
    public String foto = null;


	public RMI_Object(){
        // Inizializza tutto come "libero"
        id = "L";
        data = "L";
        giorni = -1;
        costoGiorn = -1;
        modello = "L";
        foto = "L";
    }

	@Override
    public String toString() {
        return (id + "\t" + data + "\t" + giorni + "\t"+ modello + "\t"+ costoGiorn + "\t"+ foto + "\t");
    }

}
