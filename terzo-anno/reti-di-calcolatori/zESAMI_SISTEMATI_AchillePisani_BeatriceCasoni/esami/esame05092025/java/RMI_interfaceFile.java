//NOME COGNOME 0000000000

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int unione_file(String filename, int sogliaMin, int sogliaMax) throws RemoteException, FileNotFoundException;
	
	String[] lista_nomifile_caratteri(String dirName, String maiusc, String minusc, String num) throws RemoteException, FileNotFoundException;	

}