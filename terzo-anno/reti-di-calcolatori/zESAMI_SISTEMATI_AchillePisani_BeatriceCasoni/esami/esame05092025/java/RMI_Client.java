/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
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
            int i, result;
            String nomeDirectory = null;
            String nomeFile = null,sogliaMinstring = null, sogliaMaxstring = null;
            int sogliaMin, sogliaMax;
            String maiusc = null, minusc = null, num= null;


            /* Ciclo di richieste fino a EOF ----------------------------------------- */
            System.out.println("Inserisci il servizio richiesto: 1= unione_file, 2= lista_filetesto");
            while ( (service = stdIn.readLine()) != null ){
                
                /* unione_file ======================================================== */
                if (service.equals("1")) {
                    // Variabili (da spostare) ---------------------------------------
                    result = 0;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome del file: ");
                    nomeFile = stdIn.readLine();

                    System.out.println("Inserisci sogliaMin: ");
                    sogliaMinstring = stdIn.readLine();
                    sogliaMin = Integer.parseInt(sogliaMinstring);
                    

                    System.out.println("Inserisci sogliaMax: ");
                    sogliaMaxstring = stdIn.readLine();
                    sogliaMax = Integer.parseInt(sogliaMaxstring);
                    
                    result = serverRMI.unione_file(nomeFile, sogliaMin, sogliaMax); // Chiamata RMI

                    System.out.println("Risultato: " + result );

                } 
                /* FINE unione_file ==================================================== */
                /* ------------------------------------------------------------------- */
                /* lista_nomifile_caratteri ========================================================= */

                else if (service.equals("2")) {
                    // Variabili (da spostare) ---------------------------------------
                    String[] lista;
                    
                    // Logica di business --------------------------------------------
                    System.out.println("Inserisci il nome della directory: ");
                    nomeDirectory = stdIn.readLine();

                    System.out.println("Inserisci il carattere maiuscolo: ");
                    maiusc = stdIn.readLine();

                    System.out.println("Inserisci il carattere minusc: ");
                    minusc = stdIn.readLine();

                    System.out.println("Inserisci il carattere numerico: ");
                    num = stdIn.readLine();

                    if(maiusc.length() != 1 || minusc.length() != 1 || num.length() != 1)
                    {
                        throw new Exception("uno dei 3 caratteri è sbagliato, devi rinserirli giusti!!!\n"); 
                        //oppure fai system. out e fai continue per fargli rinserire i dati, con throw exemption termina programma                      
                    }
                    
                    if(!maiusc.equals(maiusc.toUpperCase()) || !minusc.equals(minusc.toLowerCase()))
                    {
                        throw new Exception("uno dei 2 caratteri alfabetici è sbagliato, devi rinserirli giusti!!!\n");
                    }
                    Integer.parseInt(num);
                    
                    /*in alternativa al parseint
                    if (!Character.isDigit(num.charAt(0))) {
                        System.out.println("Errore: il carattere numerico non è una cifra.");
                        continue;
                    }
                    */

                    lista = serverRMI.lista_nomifile_caratteri(nomeDirectory, maiusc, minusc, num); // Chiamata RMI

                    for ( i = 0; i < lista.length; i++){
                        System.out.println("- " + lista[i]);
                    }
                    
                } 
                /* FINE lista_nomifile_caratteri ==================================================== */

                else { // Servizio non trovato
                    System.err.println("Servizio non trovato");
                }

                System.out.println("Inserisci il servizio richiesto: 1= unione_file, 2= lista_nomifile_caratteri");
            }
        } catch (EOFException eof) { /* ricevuto EOF */
            System.out.println("Inserito EOF, chiudo");
            System.exit(0);
        } catch (NotBoundException nbe) {
            System.err.println("ClientRMI: il nome fornito non risulta registrato; " + nbe.getMessage());
            nbe.printStackTrace();
            System.exit(1);
        }catch (NumberFormatException e) {
            System.err.println("ClientRMI: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        } catch (Exception e) {
            System.err.println("ClientRMI: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        } 
    }
}