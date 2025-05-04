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

    private static final int MAX_DIM_BUFFER = 256;

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
            
            String nomeDirectory = null;
            String nomeFile = null;
            char carattere;


            /* --- ciclo di richieste fino a EOF --- */
            System.out.println("Inserisci il servizio richiesto: 1 SERVIZIO1, 2 SERVIZIO2");
            while ( (service = stdIn.readLine()) != null ){
                
                /* --- switch dei servizi --- */
                if (service.equals("1")) {          // SERVIZIO 1
                    // variabili
                    int result = 0;
                    
                    // dati in ingresso
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Inserisci il carattere: ");
                    carattere = stdIn.readLine().charAt(0);
                    
                    result = serverRMI.SERVIZIO1(nomeFile, carattere);

                    System.out.println("Risultato: " + result );

                } else if (service.equals("2")) {   // SERVIZIO 2
                    // variabili
                    String[] result = new String[MAX_DIM_BUFFER];
                    
                    // dati in ingresso
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();
                    
                    result = serverRMI.SERVIZIO2(nomeDirectory, 'a', 2);

                    for (String string : result) {
                        System.out.println(" - " + string);
                    }
                    
                    
                } else {                            // SERVIZIO NON TROVATO
                    System.err.println("Servizio non trovato");
                }
                System.out.println("Inserisci il servizio richiesto: 1 SERVIZIO1, 2 SERVIZIO2");
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