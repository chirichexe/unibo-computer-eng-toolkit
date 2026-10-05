/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
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
	/* elimina_occorrenze ======================================================== */

	@Override
	public int elimina_occorrenze(String filename) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo elimina_occorrenze invocato..." + filename);
		// Variabili --------------------------------------------------------
		int i, result = 0;

		// Logica di business -----------------------------------------------
		// SOSTITUZIONE RIGHE =========================== SNIPPET
		// Variabili ------------------------------------------------
		File originalFile, tempFile = null;
		String line;

		// Algoritmo ------------------------------------------------
		originalFile = new File(filename);
		if (!originalFile.exists() || !originalFile.isFile()) {
			System.err.println("File richiesto non esiste");
			result = -1;
		} else {
			try (BufferedReader reader = new BufferedReader(new FileReader(originalFile))) {
				tempFile = File.createTempFile("tempfile", ".tmp");
				try (BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

					while ((line = reader.readLine()) != null) {

                        for(i = 0; i <line.length; i++){
                            if(Character.isDigit(line.charAt(i))){
                                result++;
                            }else{
                                writer.write(line.charAt(i));
                            }

                        }
                        writer.newLine(); // Aggiunge un terminatore di riga
                        
						// if (!line.contains(parola)) { // Condizione di scrittura
						// 	writer.write(line);
						// 	writer.newLine(); // Aggiunge un terminatore di riga
						// } else {
						// 	result ++;
						// }
					}
				}

				// Rinominazione del file temporaneo
				if (!originalFile.delete()) {
					System.err.println("Impossibile eliminare il file originale");
					result =  -2;
				}
				if (!tempFile.renameTo(originalFile)) {
					System.err.println("Impossibile rinominare il file temporaneo");
					result =  -2;
				}
			} catch (IOException e) {
				if (tempFile == null || tempFile.exists()) {
					tempFile.delete(); // Pulizia in caso di errore
				}
				e.printStackTrace();
			}
		}

		// FINE SOSTITUZIONE RIGHE ====================== SNIPPET


		// Fine logica di business ------------------------------------------
		return result < 0 ? -1 : result;
	}

	/* FINE elimina_occorrenze ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] lista_file_carattere(String dirName, char carattere, int numOccorrenze) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo lista_file_carattere invocato...");
		// Variabili --------------------------------------------------------

		String[] result;
		int i, numRes = 0;

		// Logica di business -----------------------------------------------

		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */
		// Variabili --------------------------------------------------------------------
		File file, directory;
		File[] files, subfiles;
		int arraySize, countCar = 0, index, j;

		// Algoritmo --------------------------------------------------------------------
		directory = new File(dirName);
		if (directory.exists() && directory.isDirectory()) {
			files = directory.listFiles();

			// Primo ciclo: Conta quantti file soddisfano il criterio
			arraySize = 0;
			for ( i = 0; i < files.length && arraySize < MAX_LIST_SIZE; i++) {
				file = files[i];
				if (file.isFile()) {
					System.out.println("Trovato file: " + file.getName());

                    countCar = 0;
                    for(int j = 0; i < file.getName().length(); j++){
                        if(file.getName().charAt(j) == carattere)
                            countCar++;

                    }
                    
					if (file.getName().endsWith(".txt") && countCar >= numOccorrenze) {
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
				if (file.isFile()) {
					System.out.println("Trovato file: " + file.getName());

                    countCar = 0;
                     for(int j = 0; i < file.getName().length(); j++){
                        if(file.getName().charAt(j) == carattere)
                            countCar++;
                    }
                    
					if (file.getName().endsWith(".txt") && countCar >= numOccorrenze) {
						result[index] = file.getName();
						index++;
					}
				}
			}
		} else {
			System.out.println("Errore: Directory non esiste o non è una directory");
			result = new String[1];
			result[0] = "NON ESISTE";
		}
		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */

		// Fine logica di business ------------------------------------------
		return result;
	}

	/* FINE lista_file_carattere ==================================================== */

}