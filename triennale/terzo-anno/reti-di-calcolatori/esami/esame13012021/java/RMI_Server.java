/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;
import java.rmi.*;
import java.rmi.server.*;

public class RMI_Server extends UnicastRemoteObject implements RMI_interface {
	
	private static final long serialVersionUID = 1L;
	private static int DIM_BUFF = 7;
	private final static int N = 50;
		
	/* Parametri di cofigurazione ------------------------------------------- */
	final static int REGISTRYPORT = 1099;
	final static int SERVERPORT = 1100;
	final static String registryHost = "localhost";

	public RMI_Server() throws RemoteException {
		super();
	}

	public static void main(String[] args) {
		
		/* Registrazione servizio -------------------------------------------- */
		String serviceName = "esame"; // nome default, per semplicità

		String completeName = "//" + registryHost + ":" + REGISTRYPORT + "/" + serviceName;
		try {
			RMI_Server serverRMI = new RMI_Server();
			Naming.rebind(completeName, serverRMI);
			System.out.println("Server RMI: Servizio \"" + serviceName + "\" registrato");
		} catch (Exception e) {
			System.err.println("Server RMI \"" + serviceName + "\": " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}
	}

	/* Implementazione servizi ----------------------------------------------- *
	/
	/* elimina_occorrenze ======================================================== */

	@Override
	public int elimina_occorrenze(String fileName) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo elimina_occorrenze invocato...");
		// Variabili --------------------------------------------------------
		int result = 0;

		// Logica di business -----------------------------------------------
		// Variabili ------------------------------------------------
		File tempFile = null;

		// Algoritmo ------------------------------------------------
		try (FileInputStream inputStream = new FileInputStream(fileName)) {
		    tempFile = File.createTempFile("tempfile", ".tmp");
		    try (FileOutputStream tempOutputStream = new FileOutputStream(tempFile)) {
		        byte[] buffer = new byte[1024];
		        int bytesRead;

		        // Algoritmo ------------------------------------------------
		        while ((bytesRead = inputStream.read(buffer)) > 0) {
		            for (int i = 0; i < bytesRead; ++i) {
		                if ( (char) buffer[i] < '0' || (char) buffer[i] > '9' ) { 
		                    tempOutputStream.write(buffer[i]);
		                } else {
		                	result ++ ;
		                }
		            }
		        }
		    }

		    // Rinominazione del file temporaneo ---------------------------
		    File originalFile = new File(fileName);
		    if (!originalFile.delete()) {
		        return -1;

		    }
		    if (!tempFile.renameTo(originalFile)) {
		        return -1;

		    }
		} catch (IOException e) {
		    if (tempFile != null && tempFile.exists()) {
		        tempFile.delete();
		    }
		    e.printStackTrace();
		    return -1;
		}
		return result;
	}

	/* FINE elimina_occorrenze ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] lista_sottodirettori(String dirName) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo lista_sottodirettori invocato...");
		
		/* FINE SCORRE DIRECTORY INDICE ====================================== SNIPPET */
		// Variabili --------------------------------------------------------------------

		String[] result;
		File[] files;
		File file;
		int count;

		// Algoritmo --------------------------------------------------------------------
		File directory = new File(dirName);
		if (directory.exists() && directory.isDirectory()) {
		    files = directory.listFiles();

		    // Primo ciclo: Conta quante directory soddisfano il criterio
		    int arraySize = 0;
		    for (int i = 0; i < files.length && arraySize < 6; i++) {
		        file = files[i];
		        if (file.isDirectory()) {
		            System.out.println("Trovata directory: " + file.getName());
		            File[] subfiles = file.listFiles();
		            count = 0;

		            // Conta file .txt nella sottodirectory
		            for (int j = 0; subfiles != null && j < subfiles.length; j++) {
		                if (subfiles[j].isFile() && subfiles[j].getName().endsWith(".txt")) {
		                    count++;
		                }
		            }

		            if (count >= 6) {
		                arraySize++;
		            }
		        }
		    }

		    // Allocazione array per il risultato
		    result = new String[arraySize];

		    // Secondo ciclo: Riempie l'array con i nomi delle directory valide
		    int index = 0;
		    for (int i = 0; i < files.length && index < arraySize; i++) {
		        file = files[i];
		        if (file.isDirectory()) {
		            File[] subfiles = file.listFiles();
		            count = 0;

		            // Conta file .txt nella sottodirectory
		            for (int j = 0; subfiles != null && j < subfiles.length; j++) {
		                if (subfiles[j].isFile() && subfiles[j].getName().endsWith(".txt")) {
		                    count++;
		                }
		            }

		            if (count >= 6) {
		                result[index] = file.getName();
		                index++;
		            }
		        }
		    }
		} else {
		    System.out.println("Errore: Directory non esiste o non è una directory");
		    //ERRORE
		}
		/* FINE SCORRE DIRECTORY INDICE ====================================== SNIPPET */


		return result;
	}

	/* FINE lista_sottodirettori ==================================================== */

}