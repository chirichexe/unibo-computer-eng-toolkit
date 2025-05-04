/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;
import java.rmi.*;

class RMI_Client {

    private static final int DIM_BUFF = 256;

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
            RMI_interface serverRMI = (RMI_interface) Naming.lookup(completeName);

            System.out.println("ClientRMI: Servizio \"" + serviceName + "\" connesso");

            /* Esecuzione programma -------------------------------------------------- */

            /* Variabili ------------------------------------------------------------- */
            String service = null;
            
            String nomeDirectory = null;
            String nomeFile = null;
            char carattere;

            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= elimina_occorrenze, 2= lista_sottodirettori");
            while ( (service = stdIn.readLine()) != null ){
                
                /* elimina_occorrenze ======================================================== */
                if (service.equals("1")) {
                    // Variabili -----------------------------------------------------
                    int result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Inserisci il carattere: ");
                    carattere = stdIn.readLine().charAt(0);
                    
                    result = serverRMI.elimina_occorrenze(nomeFile); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE elimina_occorrenze ==================================================== */
                /* ------------------------------------------------------------------- */
                /* lista_sottodirettori ========================================================= */

                else if (service.equals("2")) {
                    // Variabili -----------------------------------------------------
                    String[] result = new String[DIM_BUFF];
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();
                    
                    result = serverRMI.lista_sottodirettori(nomeDirectory); // Chiamata RMI
                    
                    if (result[0].equals("-1")) {
                    	System.out.println("Errore...");
                    }

                    for (int i = 0; i < result.length; i++){
                        System.out.println(" - " + result[i]);
                    }
                    
                } 
                /* FINE lista_sottodirettori ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= elimina_occorrenze, 2= lista_sottodirettori");
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