/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
*/

import java.io.*;
import java.net.*;

class ClientHandler extends Thread {
    
    private Socket clientSocket = null;
    private static int DIM_BUFF = 4096;

    public ClientHandler(Socket clientSocket) {
        this.clientSocket = clientSocket;
    }

    public void run() {
        System.out.println("Attivazione figlio: " + Thread.currentThread().getName());

        /* CREAZIONE STREAM INPUT/OUTPUT ============================================ */
        DataInputStream inSock;
        DataOutputStream outSock;
        
        try {
            inSock = new DataInputStream(clientSocket.getInputStream());
            outSock = new DataOutputStream(clientSocket.getOutputStream());
        } catch (IOException ioe) {
            System.out.println("Problemi nella creazione degli stream di input/output su socket: ");
            ioe.printStackTrace();
            return;
        }

        // Variabili -------------------------------------------------------------------
        String servizio = null;
        int risultato, i, j;
        String dirName = null;
        char carattere;
        int numOccorrenze = -1;

        /* ESECUZIONE PROGRAMMA ===================================================== */
        try{ 
            try {
                
                /* Richieste servizio fino a EOF ------------------------------------- */
                while ((servizio = inSock.readUTF()) != null) {
                    
                    /* CONTA LINEE ===================================================== */

                    if (servizio.equals("1")) {
                        dirName = inSock.readUTF();
                        carattere = inSock.readChar();
                        numOccorrenze = inSock.readInt();

                        risultato = 0;
                        
                        /* SCORRE DIRECTORY ================================== SNIPPET */
                        //  Variabili --------------------------------------------------- 
                        File directory = null;
                        File[] files = null;
                        File file = null;
                        StringBuilder currentLine = null;
                        int trovati = -1;
                        String line = null;

                        // Algoritmo -----------------------------------------------------
                        directory = new File(dirName);
                        if (directory.exists() && directory.isDirectory()) {
                            files = directory.listFiles();
                            for ( i = 0; i < files.length; i++) {
                                file = files[i];
                                System.out.println("Trovato file: " + file.getName());
                                if (file.isFile()) {
                                    
                                    // SCORRE FILE ================================== SNIPPET 

                                    try (FileInputStream fis = new FileInputStream(file);
                                    InputStreamReader isr = new InputStreamReader(fis);
                                    BufferedReader br = new BufferedReader(isr)) {

                                        while ((line = br.readLine()) != null) { 
                                            System.out.println("Riga letta: " + line);
                                            trovati = 0;
                                            for ( j = 0; j < line.length() ; j++ ){
                                                if ( line.charAt(j) == carattere ){
                                                    trovati ++;
                                                }
                                            }

                                            if ( Character.isUpperCase(line.charAt(0)) && trovati >= numOccorrenze ) {
                                                risultato ++;
                                            }
                                        }
                                        
                                    } catch (IOException e) {
                                        System.err.println("Errore durante la lettura del file: " + e.getMessage());
                                    }   

                                    // FINE SCORRE FILE ============================= SNIPPET 
                                }
                            }
                        } else {
                            outSock.writeInt(-1); // messaggio di errore
                            System.out.println("Errore: Directory non esiste o non è una directory");
                        }
                        /* FINE SCORRE DIRECTORY ============================== SNIPPET */
                        
                        outSock.writeInt(risultato);
                    } 
                    /* FINE CONTA LINEE ================================================ */
                    /* --------------------------------------------------------------- */
                    /* TRASFERISCI FILE BIN ===================================================== */
                    else if (servizio.equals("2")){
                        dirName = inSock.readUTF();
                        
                        /* INVIA UNA DIRECTORY =================================== SNIPPET */
                        // Variabili (da spostare sopra) -----------------------------------
                        long num_bytes;
                        byte[] buffer = new byte[DIM_BUFF];
                        int bytes_count = 0;
                        boolean isText = false;
                        int read_bytes = 0;
                        int character;
                        DataInputStream src_stream = null;
                        File[] files = null;
                        File file = null;

                        // Algoritmo --------------------------------------------------------
                        File directory = new File(dirName);
                        if ( !directory.exists() && !directory.isDirectory()) {
                            outSock.writeInt(-1); // messaggio di assenza directory
                            System.out.println("Directory \"" + dirName + "\" non esiste o non è una directory");
                        } else {
                            System.out.println("Invio directory \"" + dirName + "\"");
                            outSock.writeInt(0); // messaggio di successo

                            files = directory.listFiles();
                            for (i = 0; i < files.length; i++) {
                                file = files[i];
                                if (file.isFile()){
                                    System.out.println("Trovato file con nome: " + file.getName());
                                    num_bytes = file.length();


                                    try (FileInputStream fis = new FileInputStream(file);
                                    InputStreamReader isr = new InputStreamReader(fis);
                                    BufferedReader br = new BufferedReader(isr)) {
                                        
                                        while ((character = br.read()) >= 0) { 
                                            System.out.println((char) character);
                                            if ( character > 0 && character < 127) {
                                                isText = true;
                                                break;
                                            }
                                        }
                                    } catch (IOException e) {
                                        System.err.println("Errore durante la lettura del file: " + e.getMessage());
                                        continue;
                                    }
                                    if ( !file.getName().endsWith(".txt") && isText ){
                                        // Invio il nome del file
                                        outSock.writeUTF(file.getName());
                                        
                                        // Invio la lunghezza
                                        outSock.writeLong(num_bytes);

                                        // Trasferisco il file
                                        src_stream = new DataInputStream(new FileInputStream(file.getAbsolutePath()));
                                        bytes_count = 0;
                                        try {
                                            while (bytes_count < num_bytes) {
                                                read_bytes = src_stream.read(buffer);
                                                outSock.write(buffer, 0, read_bytes);
                                                bytes_count += read_bytes;
                                            }
                                            outSock.flush();

                                        } catch (EOFException e) {
                                            System.out.println("Problemi, i seguenti: ");
                                            e.printStackTrace();
                                        }
                                    }
                                    
                                }
                            }
                            outSock.writeUTF("END");
                            System.out.println("Cartella inviata con successo");
                            
                        }

                        /* FINE INVIA UNA DIRECTORY =============================== SNIPPET */                    
                    } 
                    /* FINE TRASFERISCI FILE BIN ================================================ */
                    else {                            // SERVIZIO NON PRESENTE
                        System.out.println("Servizio non presente");
                    }

                } /* ricevuto EOF */

                System.out.println("Ho terminato, chiudo il Thread");

            } catch (EOFException eof) {
                clientSocket.close();
                System.out.println("Server: inviato EOF, termino il thread " + Thread.currentThread().getName());
                System.exit(1);
            } catch (SocketTimeoutException ste) {
                System.out.println("Timeout scattato: ");
                ste.printStackTrace();
                clientSocket.close();
                System.exit(1);
            } catch (Exception e) {
                System.out.println("Problemi, i seguenti : ");
                e.printStackTrace();
                System.out.println("Chiudo ed esco...");
                clientSocket.close();
                Thread.currentThread().interrupt();
            }
        } catch (IOException e){
            System.err.println("Errore nella chiusura socket: " + e.getMessage());
            System.exit(1);
        }
    }
}

public class ServerTCP {

    public static void main(String[] args) {
        int i, port = -1;

        /* Controllo argomenti */
        try {
            if (args.length == 1) {
                port = Integer.parseInt(args[0]);
                if (port < 1024 || port > 65535) {
                    System.out.println("Usage: java ServerTCP [serverPort>1024]");
                    System.exit(1);
                }
            } else {
                System.out.println("Usage: java ServerTCP port");
                System.exit(1);
            }
        } catch (NumberFormatException e) {
            System.err.println("Errore: la porta deve essere un numero intero.");
            e.printStackTrace();
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Errore: problema non previsto.");
            e.printStackTrace();
            System.exit(1);
        }

        try (ServerSocket serverSocket = new ServerSocket(port)) {
            serverSocket.setReuseAddress(true);
            System.out.println("Server: avviato. Creata la server socket: " + serverSocket);

            while (true) {
                System.out.println("Server: in attesa di richieste...\n");

                try {
                    Socket clientSocket = serverSocket.accept();
                    System.out.println("Server: connessione accettata: " + clientSocket);

                    new ClientHandler(clientSocket).start();
                } catch (IOException e) {
                    System.err.println("Server [errore]: problemi nell'accettazione della connessione: " + e.getMessage());
                    e.printStackTrace();
                } catch (Exception e) {
                    System.err.println("Server [errore]: problema non previsto nel gestire il client: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        } catch (IOException e) {
            System.err.println("Server [errore]: problemi nella creazione della server socket: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Server [errore]: problema non previsto: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Server: terminato.");
    }
}
