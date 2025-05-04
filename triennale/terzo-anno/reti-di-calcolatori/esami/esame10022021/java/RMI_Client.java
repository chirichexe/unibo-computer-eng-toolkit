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
            int numGiorni = -1;
            String data = null;
            String id = null;

            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= elimina_sci, 2= noleggia_sci");
            while ( (service = stdIn.readLine()) != null ){
                
                /* elimina_sci ======================================================== */
                if (service.equals("1")) {
                    // Variabili -----------------------------------------------------
                    int result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci id dello sci: ");
                    id = stdIn.readLine();
                    
                    result = serverRMI.elimina_sci(id); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE elimina_sci ==================================================== */
                /* ------------------------------------------------------------------- */
                /* noleggia_sci ======================================================== */

                else if (service.equals("2")) {
                    // Variabili -----------------------------------------------------
                    int result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci id dello sci: ");
                    id = stdIn.readLine();

                    System.out.println("Inserisci data in cui noleggiare GG/MM/AAAA: ");
                    data = stdIn.readLine();
                    
                    String[] estremiData = data.split("/");
                    if (estremiData.length != 3  ){
                        System.out.println("Formato data errato");
                        continue;
                    }
                    for (int i = 0; i < 3; i++) {
                        try {
                            Integer.parseInt(estremiData[i]);
                            if (i == 3 && estremiData[i].length() != 4 || (i < 3 && estremiData[i].length() > 2)){
                                System.out.println("Formato data errato");
                                continue;                                
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("Formato data errato");
                            continue;
                        }
                    }

                    System.out.println("Inserisci giorni: ");
                    numGiorni = Integer.parseInt(stdIn.readLine());
                    
                    result = serverRMI.noleggia_sci(id, data, numGiorni); // Chiamata RMI

                    System.out.println("Risultato: " + result );
                } 
                /* FINE noleggia_sci ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= elimina_sci, 2= noleggia_sci");
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