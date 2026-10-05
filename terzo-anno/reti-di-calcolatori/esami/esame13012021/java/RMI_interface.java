/*
/// Author: Nome Cognome
/// Matricola: 0000000000
*/

import java.io.*;
import java.rmi.*;

public interface RMI_interface extends Remote {

	int elimina_occorrenze(String fileName) throws RemoteException, FileNotFoundException;
	
	String[] lista_sottodirettori(String dirName) throws RemoteException, FileNotFoundException;	

}