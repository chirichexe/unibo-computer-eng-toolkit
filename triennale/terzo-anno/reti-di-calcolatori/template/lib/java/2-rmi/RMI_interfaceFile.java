//CHIRICHELLA DAVIDE 0001071414

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int SERVIZIO1(String fileName, char carattere) throws RemoteException, FileNotFoundException;
	
	String[] SERVIZIO2(String dirName) throws RemoteException, FileNotFoundException;	

}