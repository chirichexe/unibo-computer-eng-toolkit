/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;
import java.rmi.*;

class RMI_Client {

    private static final int DIM_BUFF = 1024;
    private static final int MAX_LIST_SIZE = 6;

    public static void main(String[] args) {
        
        /* Parametri di cofigurazione ------------------------------------------- */
        final int REGISTRYPORT = 1099;
        String registryHost = null;
        String serviceName = "";
        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));

        /* Controllo argomenti -------------------------------------------------- */
        if (args.length != 2) {
            System.out.println("Sintassi: RMI_Registry_IP ServiceName");
            System.exit(1);
        }
        registryHost = args[0];
        serviceName = args[1];

        
        try {
            /* Connessione al servizio di registry ----------------------------------- */
            System.out.println("Invio richieste a " + registryHost + " per il servizio di nome " + serviceName);

            String completeName = "//" + registryHost + ":" + REGISTRYPORT + "/" + serviceName;
            RMI_interfaceFile serverRMI = (RMI_interfaceFile) Naming.lookup(completeName);

            System.out.println("ClientRMI: Servizio \"" + serviceName + "\" connesso");

            /* Esecuzione programma -------------------------------------------------- */

            /* Variabili ------------------------------------------------------------- */
            String service = null;
            int i;
            String nomeDirectory = null;
            String nomeFile = null;

            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= numerazione_righe, 2= lista_file");
            while ( (service = stdIn.readLine()) != null ){
                
                /* numerazione_righe ======================================================== */
                if (service.equals("1")) {
                    // Variabili (da spostare) ---------------------------------------
                    int result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Richiedo file " + nomeFile);
                    
                    result = serverRMI.numerazione_righe(nomeFile); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE numerazione_righe ==================================================== */
                /* ------------------------------------------------------------------- */
                /* lista_file ========================================================= */

                else if (service.equals("2")) {
                    // Variabili (da spostare) ---------------------------------------
                    String[] result;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();
                    
                    result = serverRMI.lista_file(nomeDirectory); // Chiamata RMI

                    for ( i = 0; i < result.length; i++){
                        System.out.println("- " + result[i]);
                    }
                    
                } 
                /* FINE lista_file ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= numerazione_righe, 2= lista_file");
            }
        } catch (EOFException eof) { /* ricevuto EOF */
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