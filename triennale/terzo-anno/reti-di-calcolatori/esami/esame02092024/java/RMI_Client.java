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
            int i, result;
            String nomeDirectory = null;
            String nomeFile = null;
            String parola = null;

            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= elimina_linee_contenenti_parola, 2= lista_filetesto");
            while ( (service = stdIn.readLine()) != null ){
                
                /* elimina_linee_contenenti_parola ======================================================== */
                if (service.equals("1")) {
                    // Variabili (da spostare) ---------------------------------------
                    result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Inserisci parola: ");
                    parola = stdIn.readLine();
                    
                    result = serverRMI.elimina_linee_contenenti_parola(nomeFile, parola); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE elimina_linee_contenenti_parola ==================================================== */
                /* ------------------------------------------------------------------- */
                /* lista_filetesto ========================================================= */

                else if (service.equals("2")) {
                    // Variabili (da spostare) ---------------------------------------
                    String[] lista;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();
                    
                    lista = serverRMI.lista_filetesto(nomeDirectory); // Chiamata RMI

                    for ( i = 0; i < lista.length; i++){
                        System.out.println("- " + lista[i]);
                    }
                    
                } 
                /* FINE lista_filetesto ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= elimina_linee_contenenti_parola, 2= lista_filetesto");
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