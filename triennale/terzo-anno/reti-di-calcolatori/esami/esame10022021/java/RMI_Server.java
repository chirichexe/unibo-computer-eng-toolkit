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
	static RMI_Object o[] = null; // oggetto "condiviso"

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

		/* Inizializzazione struttura dati ------------------------------------ */
		o = new RMI_Object[N];
		for (int i = 0; i < N; i++) {
			o[i] = new RMI_Object();
		}

		o[0].id = "test";
        o[0].data = "10/11/2003";
        o[0].giorni = 3;
        o[0].costoGiorn = 3;
        o[0].modello = "Modello";
        o[0].foto = "f1";

		o[1].id = "test2";
        o[1].data = "10/11/2003";
        o[1].giorni = 3;
        o[1].costoGiorn = 3;
        o[1].modello = "Modello";
        o[1].foto = "f2";
		
		o[2].id = "test3";
        o[2].data = "L";
        o[2].giorni = -1;
        o[2].costoGiorn = 3;
        o[2].modello = "Modello";
        o[2].foto = "f2";
	}

	/* Implementazione servizi ----------------------------------------------- *
	/
	/* elimina_sci ======================================================== */

	@Override
	public int elimina_sci(String id) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo elimina_sci invocato...");
		// Variabili --------------------------------------------------------
		int result = -1;

		// Logica di business -----------------------------------------------
		
		for (int i = 0; i < N; i++){
			if ( o[i].id.equals(id) ){
				result = 1;
				o[i].id = "L";
				o[i].data = "L";
				o[i].giorni = -1;
				o[i].costoGiorn = -1;
				o[i].modello = "L";
				
				File foto = new File(o[i].foto);
				foto.delete();
				
				o[i].foto = "L";
				break;
			}
		}

		System.out.println("index\tID\tDATA\tGIORNI\tMODELLO\tCOSTOG\tFOTO");
		for (int i = 0; i < N; i++){
			System.out.println( i + "\t" + o[i].toString() );	
		}

		return result;
	}

	/* FINE elimina_sci ==================================================== */
	/* ------------------------------------------------------------------- */
	/* SERVIZIO 2 ======================================================== */

	@Override
	public int noleggia_sci(String id, String data, int numGiorni) throws RemoteException, FileNotFoundException {
		System.out.println("Metodo noleggia_sci invocato per id..." + id);
		// Variabili --------------------------------------------------------
		int result = -1;

		// Logica di business -----------------------------------------------
		for (int i = 0; i < N; i++){
			if ( o[i].id.equals(id) ){
				if (o[i].giorni > 0 || !o[i].data.equals("L") ) {
					result = -2;
					break;
				} else {
					o[i].giorni = numGiorni;
					o[i].data = data;
					result = 1;
				}
			}
		}
		
		System.out.println("index\tID\tDATA\tGIORNI\tMODELLO\tCOSTOG\tFOTO");
		for (int i = 0; i < N; i++){
			System.out.println( i + "\t" + o[i].toString() );	
		}

		return result;
	}

	/* FINE noleggia_sci ==================================================== */

}