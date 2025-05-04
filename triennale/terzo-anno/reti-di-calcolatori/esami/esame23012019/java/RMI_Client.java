/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.EOFException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.rmi.Naming;
import java.rmi.NotBoundException;

class RMI_Client {

    private static final int MAX_DIM_BUFFER = 7;

    public static void main(String[] args) {
        
        /* --- parametri di configurazione --- */
        final int REGISTRYPORT = 1099;
        String registryHost = null;
        String serviceName = "";
        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));

        /* --- controllo argomenti --- */
        if (args.length != 2) {
            System.out.println("Sintassi: RMI_Registry_IP ServiceName");
            System.exit(1);
        }
        registryHost = args[0];
        serviceName = args[1];

        
        try {
            /* --- connessione al servizio di registry --- */
            System.out.println("Invio richieste a " + registryHost + " per il servizio di nome " + serviceName);

            String completeName = "//" + registryHost + ":" + REGISTRYPORT + "/" + serviceName;
            RMI_interface serverRMI = (RMI_interface) Naming.lookup(completeName);

            System.out.println("ClientRMI: Servizio \"" + serviceName + "\" connesso");

            // --- variabili ---
            String service = null;
            
            String numTarga = null;
            String tipoVeicolo = null;

            /* --- ciclo di richieste fino a EOF --- */
            System.out.println("Inserisci il servizio richiesto: 1 elimina_prenotazione, 2 visualizza_prenotazioni");
            while ( (service = stdIn.readLine()) != null ){
                
                /* --- switch dei servizi --- */
                if (service.equals("1")) {          // SERVIZIO 1
                    // variabili
                    int result = 0;
                    
                    // dati in ingresso
                    System.out.println("Inserisci il num targa: ");
                    numTarga = stdIn.readLine();

                    result = serverRMI.elimina_prenotazione(numTarga);

                    if ( result < 0){
                        System.out.println("Errore nella prenotazione. Stato: " + result );
                    } else {
                        System.out.println("Prenotazione avvenuta");
                    }

                } else if (service.equals("2")) {   // SERVIZIO 2
                    // variabili
                    String[][] result = new String[MAX_DIM_BUFFER][4];
                    
                    // dati in ingresso
                    System.out.println("Inserisci il tipo di veicolo: ");
                    tipoVeicolo = stdIn.readLine();
                    
                    result = serverRMI.visualizza_prenotazioni(tipoVeicolo);

                    System.out.println("\tTARGA\tPATENTE\tAUTO\tCARTELLA FOTO\n");
                    for (int k = 0; k < result.length; k++) {
                        String line = new String((k + 1) + "|");
                        for (int j = 0; j < 4; j++) {
                            line += "\t" + result[k][j];
                        }
                        line += "\n";
                        System.out.println(line);
                    }
                    
                } else {                            // SERVIZIO NON TROVATO
                    System.err.println("Servizio non trovato");
                }
                System.out.println("Inserisci il servizio richiesto: 1 elimina_prenotazione, 2 visualizza_prenotazioni");
            }
        } catch (EOFException eof) {
            System.out.println("Inserito EOF, chiudo");
            System.exit(0);
        } catch (NotBoundException nbe) {
            System.err.println("ClientRMI: il nome fornito non risulta registrato; " + nbe.getMessage());
            nbe.printStackTrace();
            System.exit(1);
        } catch (Exception e) {
            System.err.println("ClientRMI: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}