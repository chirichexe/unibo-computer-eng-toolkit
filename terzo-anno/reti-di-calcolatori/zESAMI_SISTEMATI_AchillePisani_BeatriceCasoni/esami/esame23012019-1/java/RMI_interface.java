/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.io.FileNotFoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RMI_interface extends Remote {

	int elimina_prenotazione(String numTarga) throws RemoteException, FileNotFoundException;
	
	String[][] visualizza_prenotazioni(String tipoVeicolo) throws RemoteException, FileNotFoundException;	

}