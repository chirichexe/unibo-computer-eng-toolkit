/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int numerazione_righe(String fileName) throws RemoteException, FileNotFoundException;
	
	String[] lista_file(String dirName) throws RemoteException, FileNotFoundException;	

}