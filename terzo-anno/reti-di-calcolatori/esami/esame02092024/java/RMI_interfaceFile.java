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

	int elimina_linee_contenenti_parola(String fileName, String parola) throws RemoteException, FileNotFoundException;
	
	String[] lista_filetesto(String dirName) throws RemoteException, FileNotFoundException;	

}
