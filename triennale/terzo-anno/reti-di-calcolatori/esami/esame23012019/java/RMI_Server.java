/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

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
	private static int MAX_DIM_BUFFER = 9;
	
	// --- parametri di configurazione ---
	final static int REGISTRYPORT = 1099;
	final static int SERVERPORT = 1100;
	final static String registryHost = "localhost";

	public RMI_Server() throws RemoteException {
		super();
	}

	// oggetto condiviso
	RentACar rar = new RentACar();

	public static void main(String[] args) {
		
		// --- registrazione servizio RMI ---
		String serviceName = "esame";

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
	public int elimina_prenotazione(String numTarga) throws RemoteException, FileNotFoundException {
		// variabili
		int result = 0;

		System.out.println("elimina_prenotazione invocato...");

		// ---- logica di business ----

		result = rar.elimina_prenotazione(numTarga);

		// ---- fine: logica di business ----

		return result;
	}

	@Override
	public String[][] visualizza_prenotazioni(String tipoVeicolo) throws RemoteException, FileNotFoundException {
		String[][] result = new String[MAX_DIM_BUFFER][4];

		result = rar.visualizza_prenotazioni(tipoVeicolo);

		return result;
	}
}