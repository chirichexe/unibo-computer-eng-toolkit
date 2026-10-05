/*
/// Author: Nome Cognome
/// Matricola: 0000000000
*/

import java.io.FileNotFoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RMI_interface extends Remote {

	int elimina_prenotazione(String numTarga) throws RemoteException, FileNotFoundException;
	
	String[][] visualizza_prenotazioni(String tipoVeicolo) throws RemoteException, FileNotFoundException;	

}