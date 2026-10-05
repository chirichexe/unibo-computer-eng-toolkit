/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.io.*;
import java.rmi.*;

public interface RMI_interface extends Remote {

	int elimina_sci(String id) throws RemoteException, FileNotFoundException;
	
	int noleggia_sci(String id, String data, int numGiorni) throws RemoteException, FileNotFoundException;	

}