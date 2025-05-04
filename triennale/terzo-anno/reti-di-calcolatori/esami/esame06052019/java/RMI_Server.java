/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

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
	/* numerazione_righe ======================================================== */

	@Override
	public int numerazione_righe(String filename) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo numerazione_righe invocato..." + filename);
		// Variabili --------------------------------------------------------
		File originalFile = null;
		File tempFile = null;
		byte[] buffer = null;
		int numLinea;
		int dispari;
		String line = null;

		// Logica di business -----------------------------------------------

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

					BufferedReader reader = new BufferedReader(new FileReader(filename));
					
					numLinea = 0;
					dispari = 0;
					while ((line = reader.readLine()) != null) {
						if ( numLinea % 2 == 0 ){
							line = dispari + line + "\n";
							dispari++;
						} else {
							line += "\n";
						}
						tempOutputStream.write(line.getBytes());
						numLinea ++;
					}
				}

				// Rinominazione del file temporaneo 
				originalFile = new File(filename);
				if (!originalFile.delete()) {
					System.err.println("Impossibile eliminare il file originale");
					return -1;

				}
				if (!tempFile.renameTo(originalFile)) {
					System.err.println("Impossibile rinominare il file temporaneo");
					return -1;

				}
			} catch (IOException e) {
				if ( tempFile == null || tempFile.exists()) {
					tempFile.delete(); // Pulizia in caso di errore
				}
				e.printStackTrace(); 
				return -2;
			}
		}

		// Fine logica di business ------------------------------------------
		return dispari;
	}

	/* FINE numerazione_righe ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] lista_file(String dirName) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo lista_file invocato...");
		// Variabili --------------------------------------------------------

		String[] result = new String[MAX_LIST_SIZE];
		result[0] = "NESSUN FILE TROVATO";

		int i, j, trovati = 0; 
		int numRes = 0;
		File file, directory;
		File[] files;
		int arraySize;

		// Logica di business -----------------------------------------------

		// Algoritmo --------------------------------------------------------------------
		directory = new File(dirName);
		if (directory.exists() && directory.isDirectory()) {
			files = directory.listFiles();

			// Memorizza file che soddisfano il criterio
			arraySize = 0;
			for ( i = 0; i < files.length && arraySize < MAX_LIST_SIZE; i++) {
				file = files[i];
				if (file.isFile()) {
					System.out.println("Trovato file: " + file.getName());

					trovati = 0;
					for ( j = 0; j < file.getName().length() ; j++ ){
						if ( file.getName().charAt(j) != 'a' && file.getName().charAt(j) != 'A' && 
						file.getName().charAt(j) != 'e' && file.getName().charAt(j) != 'R' &&
						file.getName().charAt(j) != 'i' && file.getName().charAt(j) != 'I' &&
						file.getName().charAt(j) != 'o' && file.getName().charAt(j) != 'O' &&
						file.getName().charAt(j) != 'u' && file.getName().charAt(j) != 'U')
						{
							trovati ++;
						}
					}				
				}

				// condizioni di aggiunta alla lista
				if ( trovati >= 3 ) {
					result[arraySize] = file.getName();
					arraySize ++;
				}
			}

		} else {
			System.out.println("Errore: Directory non esiste o non è una directory");
			result[0] = "DIRECTORY MANCANTE";
		}
		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */

		// Fine logica di business ------------------------------------------
		return result;
	}

	/* FINE lista_file ==================================================== */

}