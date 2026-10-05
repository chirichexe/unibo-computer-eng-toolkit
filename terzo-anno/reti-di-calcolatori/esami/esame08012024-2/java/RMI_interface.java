/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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