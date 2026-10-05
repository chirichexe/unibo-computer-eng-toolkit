/*
/// Author: Nome Cognome
/// Matricola: 0000000000
*/

import java.io.*;
import java.rmi.*;

public interface RMI_interface extends Remote {

	int elimina_sci(String id) throws RemoteException, FileNotFoundException;
	
	int noleggia_sci(String id, String data, int numGiorni) throws RemoteException, FileNotFoundException;	

}