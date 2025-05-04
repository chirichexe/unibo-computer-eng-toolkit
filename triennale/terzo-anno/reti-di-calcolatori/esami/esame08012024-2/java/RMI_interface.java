
/**
 * Interfaccia remota di servizio
 */

import java.io.FileNotFoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RMI_interface extends Remote {

	int SERVIZIO1(String fileName, char carattere) throws RemoteException, FileNotFoundException;
	
	String[] SERVIZIO2(String dirName, char carattere, int nOcc) throws RemoteException, FileNotFoundException;	

}