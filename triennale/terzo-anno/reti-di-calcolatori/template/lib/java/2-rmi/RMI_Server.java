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
	static RMI_Object t[] = null; // oggetto "condiviso"

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

		/* Inizializzazione struttura dati ------------------------------------ */
		t = new RMI_Object[N];
		for (i = 0; i < N; i++) {
			t[i] = new RMI_Object();
		}

		// Valori inizializzati per i test
		t[0].setDATO1("DATO11");
		t[0].setDATO2("DATO21");

		t[1].setDATO1("DATO12");
		t[1].setDATO2("DATO22");

		/* Fine inizializzazione struttura dati -------------------------------- */
	}

	/* Implementazione servizi ----------------------------------------------- *
	/
	/* SERVIZIO1 ======================================================== */

	@Override
	public int SERVIZIO1(String fileName, char carattere) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo SERVIZIO1 invocato...");
		// Variabili --------------------------------------------------------
		int i, result = 0;

		// Logica di business -----------------------------------------------

		System.out.println("index\tDATO1\tDATO2 \n");
		for (i = 0; i < N; i++){
			System.out.println( t[i].toString());	
		}

		return result;
	}

	/* FINE SERVIZIO1 ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public String[] SERVIZIO2(String dirName) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo SERVIZIO2 invocato...");
		// Variabili --------------------------------------------------------

		String[] result = new String[MAX_LIST_SIZE];
		int i, numRes = 0;

		// Logica di business -----------------------------------------------

		return result;
	}

	/* FINE SERVIZIO2 ==================================================== */

}