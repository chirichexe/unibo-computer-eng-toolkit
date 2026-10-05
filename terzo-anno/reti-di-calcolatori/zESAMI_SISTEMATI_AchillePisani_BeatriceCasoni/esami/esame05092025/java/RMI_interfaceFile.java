/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.io.*;
import java.rmi.*;

public interface RMI_interfaceFile extends Remote {

	int unione_file(String filename, int sogliaMin, int sogliaMax) throws RemoteException, FileNotFoundException;
	
	String[] lista_nomifile_caratteri(String dirName, String maiusc, String minusc, String num) throws RemoteException, FileNotFoundException;	

}