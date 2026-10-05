//NOME COGNOME 0000000000

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int elimina_linee_contenenti_parola(String fileName, String parola) throws RemoteException, FileNotFoundException;
	
	String[] lista_filetesto(String dirName) throws RemoteException, FileNotFoundException;	

}