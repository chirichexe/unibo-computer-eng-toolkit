//NOME COGNOME 0000000000

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int elimina_occorrenze(String fileName) throws RemoteException, FileNotFoundException;
	
	String[] lista_file_carattere(String dirName, char carattere, int numOccorrenze) throws RemoteException, FileNotFoundException;	

}