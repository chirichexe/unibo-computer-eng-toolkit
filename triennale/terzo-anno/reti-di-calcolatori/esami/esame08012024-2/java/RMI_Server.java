import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;


public class RMI_Server extends UnicastRemoteObject implements RMI_interface {
	private static final long serialVersionUID = 1L;
	private static int MAX_DIM_BUFFER = 7;
	
	// Parametri di configurazione
	final static int REGISTRYPORT = 1099;
	final static int SERVERPORT = 1100;
	final static String registryHost = "localhost";

	// Costruttore vuoto
	public RMI_Server() throws RemoteException {
		super();
	}

	public static void main(String[] args) {
		
		// Nome servizio
		String serviceName = "esame";

		// Registrazione del servizio RMI
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

	/* ---- IMPLEMENTAZIONE SERVIZI ---- */

	@Override
	public int SERVIZIO1(String fileName, char carattere) throws RemoteException, FileNotFoundException {
		// variabili
		int result = 0;
		File file;

		System.out.println("SERVIZIO1 invocato...");

		// ---- logica di business ----
		file = new File(fileName);
		if (!file.exists() || !file.isFile() ){
			System.out.println("Errore: file " + fileName + " non esiste ");
			return -1;
		} else {
			
			String fileContent = "";

			// ---- legge le righe dei file -----			SNIPPET
			try (FileInputStream fis = new FileInputStream(file);
				InputStreamReader isr = new InputStreamReader(fis);
				BufferedReader br = new BufferedReader(isr)) {
				
				// --- scorro il file caratteri ---			SNIPPET
				int character;
				while ((character = br.read()) != -1) {
					if ( character != carattere ){
						fileContent += (char) character;
					} else {
						result++;
					}
				}
				// --- fine: scorro il file caratteri ---	SNIPPET				
				
			} catch (IOException e) {
				System.err.println("Errore durante la lettura del file: " + e.getMessage());
				return -1;
			}
			// ---- fine: legge le righe dei file -----		SNIPPET

			// ---- sovrascrive contenuto file --------		SNIPPET
			try (FileOutputStream fos = new FileOutputStream(file);
				OutputStreamWriter osw = new OutputStreamWriter(fos);
				BufferedWriter bw = new BufferedWriter(osw)) {

				bw.write(fileContent);

			} catch (IOException e) {
				System.err.println("Errore durante la scrittura nel file: " + e.getMessage());
				return -1;
			}
			// ---- fine: sovrascrive contenuto file ---- 	SNIPPET

		}
		// ---- fine: logica di business ----

		return result;
	}

	@Override
	public String[] SERVIZIO2(String dirName, char carattere, int nOcc) throws RemoteException, FileNotFoundException {
		String[] result = new String[MAX_DIM_BUFFER];
		int numRes = 0;

		// ---- scorre una directory -----                      SNIPPET
		File directory = new File(dirName);
		if (directory.exists() && directory.isDirectory()) {
			File[] files = directory.listFiles();
			for (int i = 0; i < files.length; i++) {
				File file = files[i];
				if (file.isFile()) {
					System.out.println("Trovato file: " + file.getName());
					
					char[] caratteriNome = file.getName().toCharArray();
					int numcar = 0;
					for (char c : caratteriNome) {
						if (c == carattere)
							numcar++;
					}
					
					if (numcar >= nOcc){
						result[numRes] = file.getName();
						numRes++;
					}	
				}
			}
		} else {
			System.err.println("Errore: directory " + dirName + " non trovata");
			return result;
		}
		// ---- scorre una directory: fine -----                SNIPPET

		return result;
	}
}