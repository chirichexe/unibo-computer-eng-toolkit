//CHIRICHELLA DAVIDE 0001071414

import java.io.*;
import java.rmi.*;
import java.rmi.server.*;

public class RMI_Server extends UnicastRemoteObject implements RMI_interfaceFile {
	
	private static final long serialVersionUID = 1L;
	private static int DIM_BUFF = 1024;
	private final static int N = 50;
	private final static int MAX_LIST_SIZE = 6;
		
	/* Parametri di cofigurazione ------------------------------------------- */
	final static int REGISTRYPORT = 1099;
	final static int SERVERPORT = 1100;
	final static String registryHost = "localhost";

	public RMI_Server() throws RemoteException {
		super();
	}

	public static void main(String[] args) {
		
		/* Registrazione servizio -------------------------------------------- */
		String serviceName = "esame"; // nome servizio default, per semplicità
		int i;

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
	/* SERVIZIO1 ======================================================== */

	@Override
	public int SERVIZIO1(String filename, char carattere) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo SERVIZIO1 invocato..." + filename + carattere);
		// Variabili --------------------------------------------------------
		int i, result = 0;

		// Logica di business -----------------------------------------------

		// SOSTITUZIONE CARATTERI =========================== SNIPPET
		// Variabili ------------------------------------------------
		File originalFile = null;
		File tempFile = null;
		byte[] buffer = null;
		int bytesRead;

		// Algoritmo ------------------------------------------------
		buffer = new byte[DIM_BUFF];
		originalFile = new File(filename);
		if ( !originalFile.exists() || !originalFile.isFile() ){
			System.err.println("File richiesto non esise");
			return -1;
		} else {
			try (FileInputStream inputStream = new FileInputStream(filename)) {
				tempFile = File.createTempFile("tempfile", ".tmp");
				try (FileOutputStream tempOutputStream = new FileOutputStream(tempFile)) {

					while ((bytesRead = inputStream.read(buffer)) > 0) {
						for ( i = 0; i < bytesRead; i++ ) {
							if (!Character.isAlphabetic((char) buffer[i])) { // condizione di scrittura
								tempOutputStream.write(buffer[i]);
								//tempOutputStream.write(stringa.getBytes()); // Scrive una stringa
							}
						}
					}
				}

				// Rinominazione del file temporaneo 
				originalFile = new File(filename);
				if (!originalFile.delete()) {
					System.err.println("Impossibile eliminare il file originale");
					return -2;

				}
				if (!tempFile.renameTo(originalFile)) {
					System.err.println("Impossibile rinominare il file temporaneo");
					return -2;

				}
			} catch (IOException e) {
				if ( tempFile == null || tempFile.exists()) {
					tempFile.delete(); // Pulizia in caso di errore
				}
				e.printStackTrace(); 
				return -2;
			}
		}

		// FINE SOSTITUZIONE CARATTERI ====================== SNIPPET

		// Fine logica di business ------------------------------------------
		return result;
	}

	/* FINE SERVIZIO1 ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] SERVIZIO2(String dirName) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo SERVIZIO2 invocato...");
		// Variabili --------------------------------------------------------

		String[] result;
		int i, numRes = 0;

		// Logica di business -----------------------------------------------

		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */
		// Variabili --------------------------------------------------------------------
		File file, directory;
		File[] files, subfiles;
		int arraySize, count, index, j;
		int parametro = 2;

		// Algoritmo --------------------------------------------------------------------
		directory = new File(dirName);
		if (directory.exists() && directory.isDirectory()) {
			files = directory.listFiles();

			// Primo ciclo: Conta quante directory soddisfano il criterio
			arraySize = 0;
			for ( i = 0; i < files.length && arraySize < MAX_LIST_SIZE; i++) {
				file = files[i];
				if (file.isDirectory()) {
					System.out.println("Trovata directory: " + file.getName());
					subfiles = file.listFiles();
					count = 0;

					// Conta file .txt nella sottodirectory
					for ( j = 0; subfiles != null && j < subfiles.length; j++) {
						if (subfiles[j].isFile() && subfiles[j].getName().endsWith(".txt")) {
							count++;
						}
					}

					if (count >= parametro) {
						arraySize++;
					}
				}
			}

			// Allocazione array per il risultato
			result = new String[arraySize];

			// Secondo ciclo: Riempie l'array con i nomi delle directory valide
			index = 0;
			for (i = 0; i < files.length && index < arraySize; i++) {
				file = files[i];
				if (file.isDirectory()) {
					subfiles = file.listFiles();
					count = 0;

					// Conta file .txt nella sottodirectory
					for (j = 0; subfiles != null && j < subfiles.length; j++) {
						if (subfiles[j].isFile() && subfiles[j].getName().endsWith(".txt")) {
							count++;
						}
					}

					if (count >= parametro ) {
						result[index] = file.getName();
						index++;
					}
				}
			}
		} else {
			System.out.println("Errore: Directory non esiste o non è una directory");
			result = new String[1];
			result[0] = "ERRORE";
		}
		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */

		// Fine logica di business ------------------------------------------
		return result;
	}

	/* FINE SERVIZIO2 ==================================================== */

}