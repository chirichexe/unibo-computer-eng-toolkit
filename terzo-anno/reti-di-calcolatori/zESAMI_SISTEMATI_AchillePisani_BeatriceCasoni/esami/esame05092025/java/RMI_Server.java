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
	/* unione_file ======================================================== */

    /*ottiene il file unione di tutti i file di testo presenti sul direttorio, la cui dim del file è compresa
    tra due sogli min e max specificate da utente */
	@Override
	public int unione_file(String filename, int sogliaMin, int sogliaMax) throws RemoteException, FileNotFoundException {
        System.out.println("Metodo unione_file invocato..." + filename + sogliaMin + sogliaMax);

        // Variabili --------------------------------------------------------
        int result = 0;
        File originalFile;
        String line;
        String dir;

        // Logica di business -----------------------------------------------
        // SOSTITUZIONE RIGHE =========================== SNIPPET

        // Variabili ------------------------------------------------
        dir = System.getProperty("user.dir"); // directory corrente del server
        File folder = new File(dir);
        File[] listOfFiles = folder.listFiles(); // tutti i file nella directory corrente
        File tempFile = null;

        // Algoritmo ------------------------------------------------
        if (listOfFiles != null) {
            try {
                // Creo un file temporaneo per scrivere il contenuto dei file da unire
                //lo metto all inizio perche voglio che tutti i file vengano scritti qui e non che ogni volta che trovo il file
                //ci scrivo solo quello
                tempFile = File.createTempFile("temp_unione_", ".tmp");

                try (BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

                    for (int i = 0; i < listOfFiles.length; i++) {
                        if (listOfFiles[i].isFile()) {
                            System.out.println("File " + listOfFiles[i].getName());

                            // Controllo la dimensione del file rispetto alle soglie
                            if (listOfFiles[i].length() > sogliaMin && listOfFiles[i].length() < sogliaMax) {
                                // Opzionale: puoi filtrare solo file .txt, se richiesto
                                // if (!file.getName().endsWith(".txt")) continue;
                                result++;

                                //copio il contenuto del file che soddisfa le condizioni, nel file temp
                                originalFile = listOfFiles[i];
                                if (!originalFile.exists()) {
                                    System.err.println("File richiesto non esiste");
                                    return -1;
                                } else {
                                    try (BufferedReader reader = new BufferedReader(new FileReader(originalFile))) {
                                        while ((line = reader.readLine()) != null) {
                                            // Condizione di scrittura
                                            writer.write(line);
                                            writer.newLine(); // Aggiunge un terminatore di riga                                        
                                        }
                                    } catch (IOException e) {
                                        System.err.println("Errore nella lettura del file: " + originalFile.getName());
                                        e.printStackTrace();
                                        return -1;
                                    }

                                    // Rimuovo il file originale dal file system del server
                                    if (!originalFile.delete()) {
                                        System.err.println("Impossibile eliminare il file originale: " + originalFile.getName());
                                        return -2;
                                    }
                                }
                            }
                        } else if (listOfFiles[i].isDirectory()) {
                            System.out.println("Directory " + listOfFiles[i].getName());
                            continue; // ignora directory
                        }
                    }
                }

                // Rinominazione del file temporaneo con il nome richiesto dall'utente
                File fileFinale = new File(filename);
                if (fileFinale.exists()) {
                    if (!fileFinale.delete()) {
                        System.err.println("Impossibile sovrascrivere il file esistente.");
                        return -2;
                    }
                }

                if (!tempFile.renameTo(fileFinale)) {
                    System.err.println("Impossibile rinominare il file temporaneo");
                    return -2;
                }

            } catch (IOException e) {
                System.err.println("Errore durante la scrittura del file temporaneo.");
                if (tempFile != null && tempFile.exists()) {
                    tempFile.delete(); // Pulizia in caso di errore
                }
                e.printStackTrace();
                return -2;
            }
        }

        // FINE copiaggio RIGHE ====================== SNIPPET

        // Fine logica di business ------------------------------------------
        return result < 0 ? -1 : result;
    }


	/* FINE unione_file ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

    /*public static boolean isNumeric(String str)
    {
        try
        {
            Integer.parseInt(str);
            return true;
        }
        catch (NumberFormatException e)
        {
            return false;
        }
    }

    static boolean allUpper1(String input)
    {
        return input.equals(input.toUpperCase());
    }

    static boolean allLower1(String input)
    {
        return input.equals(input.toLowerCase());
    } */

   /*riceve la lista dei nomi file binari il cui nome contenga almeno 1 char maiusc, 1 minusc
   e 1 numerico, specificati da utente, in un dir spec da utente */
	@Override
	public String[] lista_nomifile_caratteri(String dirName, String maiusc, String minusc, String num) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo lista_nomifile_caratteri invocato...");
		// Variabili --------------------------------------------------------

		String[] result;
		int i, numRes = 0;

		// Logica di business -----------------------------------------------

		/* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */
		// Variabili --------------------------------------------------------------------
		File file, directory;
		File[] files, subfiles;
		int arraySize, count, index, j;

        /*
        if(!isNumeric(num) || !allLower1(minusc) || !allUpper1(maiusc) ){}
            System.out.println("Errore: Directory non esiste o non è una directory");
			result = new String[1];
			result[0] = "NON ESISTE";
        }
         */

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

                    // Opzionale: solo file .txt vengono skippati
                    if (file.getName().endsWith(".txt")) continue;

                    if(file.getName().contains(maiusc) && file.getName().contains(minusc) && file.getName().contains(num))
                        arraySize++;
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

                    // Opzionale: solo file .txt vengono skippati
                    if (file.getName().endsWith(".txt")) continue;

                    if(file.getName().contains(maiusc) && file.getName().contains(minusc) && file.getName().contains(num)){
                        result[index] = file.getName();
						index++;
                    }

					// if (file.getName().endsWith(".txt")) {
					// 	result[index] = file.getName();
					// 	index++;
					// }
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

	/* FINE lista_filetesto ==================================================== */
/* servizio 2 se non avessi in ingresso i 3 caratteri alfabetici e quello numerico
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] lista_nomifile_caratteri(String dirName) throws RemoteException, FileNotFoundException {
        System.out.println("Metodo lista_nomifile_caratteri invocato...");
        // Variabili --------------------------------------------------------

        String[] result;
        int i, numRes = 0;

        // Logica di business -----------------------------------------------

        /* FINE SCORRE SOTTODIRECTORY INDICE ====================================== SNIPPET */
        // Variabili --------------------------------------------------------------------
        File file, directory;
        File[] files, subfiles;
        int arraySize, count, index;
        int isApper = 0, isDigit = 0, isLower = 0;

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
                    String nomeFile = file.getName();
                    if (!file.getName().endsWith(".txt")) {
                        for(int j = 0; j< file.getName().length(); j++) {
                            
                            if( nomeFile.charAt(i) == Character.toUpperCase(nomeFile.charAt(i)))
                                isApper ++;
                            if(nomeFile.charAt(i) == Character.toLowerCase(nomeFile.charAt(i)))
                                isLower ++;
                            if(Character.isDigit(nomeFile.charAt(i)))
                                isDigit ++;
                            
                        }
                        if(isApper >=1 && isLower >= 1 && isDigit >= 1)
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

                    String nomeFile = file.getName();
                    if (!file.getName().endsWith(".txt")) {
                        for(int j = 0; j< file.getName().length(); j++) {
                            
                            if( nomeFile.charAt(i) == Character.toUpperCase(nomeFile.charAt(i)))
                                isApper ++;
                            if(nomeFile.charAt(i) == Character.toLowerCase(nomeFile.charAt(i)))
                                isLower ++;
                            if(Character.isDigit(nomeFile.charAt(i)))
                                isDigit ++;
                            
                        }
                        if(isApper >=1 && isLower >= 1 && isDigit >= 1) {
                            result[index] = file.getName();
                            index++;
                        }
                    }
//					if (file.getName().endsWith(".txt")) {
//						result[index] = file.getName();
//						index++;
//					}
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
*/
        /* FINE lista_nomifile_caratteri ==================================================== */

}