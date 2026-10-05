//NOME COGNOME 0000000000

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int elimina_occorrenze(String fileName) throws RemoteException, FileNotFoundException;
	
	String[] lista_filetesto(String dirName) throws RemoteException, FileNotFoundException;	

}