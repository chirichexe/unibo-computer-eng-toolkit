//CHIRICHELLA DAVIDE 0001071414

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
            char carattere;

            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= SERVIZIO1, 2= SERVIZIO2");
            while ( (service = stdIn.readLine()) != null ){
                
                /* SERVIZIO1 ======================================================== */
                if (service.equals("1")) {
                    // Variabili (da spostare) ---------------------------------------
                    int result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Inserisci il carattere: ");
                    // Controllo carattere
                    carattere = ' ';

                    do {
                        System.out.println("Inserisci carattere:");
                        String input = stdIn.readLine();
                        if (input.length() == 1) {
                            carattere = input.charAt(0);
                            if (carattere < 'a' || carattere > 'z') {
                                System.out.println("Carattere inserito non valido");
                                carattere = ' ';
                            }
                        } else {
                            System.out.println("Inserisci un solo carattere");
                        }
                    } while (carattere == ' ');
                    
                    result = serverRMI.SERVIZIO1(nomeFile, carattere); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE SERVIZIO1 ==================================================== */
                /* ------------------------------------------------------------------- */
                /* SERVIZIO2 ========================================================= */

                else if (service.equals("2")) {
                    // Variabili (da spostare) ---------------------------------------
                    String[] result = new String[MAX_LIST_SIZE];
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();
                    
                    result = serverRMI.SERVIZIO2(nomeDirectory); // Chiamata RMI

                    for ( i = 0; i < result.length; i++){
                        System.out.println("- " + result[i]);
                    }
                    
                } 
                /* FINE SERVIZIO2 ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= SERVIZIO1, 2= SERVIZIO2");
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