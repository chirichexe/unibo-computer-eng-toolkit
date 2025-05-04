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

        /* ESECUZIONE PROGRAMMA ===================================================== */
        try{ 
            try {
            
                String servizio;
                
                /* Richieste servizio fino a EOF ------------------------------------- */
                while ((servizio = inSock.readUTF()) != null) {
                    
                    int risultato = 0;
                    String filename;
                    String parola;
                    String dirName;
                    int soglia;
                    File tempFile = null;
                    long numeroByte;
                    byte[] buffer = new byte[DIM_BUFF];
                    int cont = 0;
                    int read_bytes = 0;
                    DataInputStream src_stream = null;

                    /* ELIMINA OCC. PAROLA ===================================================== */

                    if (servizio.equals("1")) {
                        /*  Variabili ------------------------------------------------ */ 
                        filename = inSock.readUTF();     // prende nome directory
                        parola = inSock.readUTF();
                        // SOSTITUZIONE CARATTERI =========================== SNIPPET
                        // Variabili ------------------------------------------------

                        // Algoritmo ------------------------------------------------
                        try (FileInputStream inputStream = new FileInputStream(filename);
                            InputStreamReader isr = new InputStreamReader(inputStream);
                            BufferedReader br = new BufferedReader(isr)) 
                        {
                            tempFile = File.createTempFile("tempfile", ".tmp");
                            try (FileOutputStream tempOutputStream = new FileOutputStream(tempFile)) {  
                                int bytesRead;

                                // Algoritmo ------------------------------------------------
                                String line;
                                while ((line = br.readLine()) != null) { 
                                    System.out.println("Riga letta: " + line);
                                    String [] substrings = line.split(" ");
                                    for ( int i = 0; i < substrings.length ; i++ ){
                                        if ( !substrings[i].equals(parola)){
                                            tempOutputStream.write(substrings[i].getBytes());
                                            tempOutputStream.write(' ');
                                        } else {
                                            risultato ++;
                                        }
                                    }
                                    tempOutputStream.write('\n');
                                }
                            }

                            // Rinominazione del file temporaneo ---------------------------
                            File originalFile = new File(filename);
                            if (!originalFile.delete()) {
                                System.err.println("Impossibile eliminare il file originale");
                                risultato = -1;
                                outSock.writeInt(risultato);
                                continue;
                            }
                            if (!tempFile.renameTo(originalFile)) {
                                System.err.println("Impossibile rinominare il file temporaneo");
                                risultato = -1;
                                outSock.writeInt(risultato);
                                continue;
                            }
                        } catch (IOException e) {
                            if (tempFile != null && tempFile.exists()) {
                                tempFile.delete(); // Pulizia in caso di errore
                            }
                            e.printStackTrace();
                            risultato = -1;
                            outSock.writeInt(risultato);
                            continue;
                        }

                        // FINE SOSTITUZIONE CARATTERI ====================== SNIPPET
                        
                        outSock.writeInt(risultato);
                    } 
                    /* FINE ELIMINA OCC. PAROLA ================================================ */
                    /* --------------------------------------------------------------- */
                    /* RICEVI FILE SOPRA SOGLIA ===================================================== */
                    else if (servizio.equals("2")){
                        dirName = inSock.readUTF();
                        soglia = inSock.readInt();
                        
                        /* INVIA UNA DIRECTORY =================================== SNIPPET */

                        /* Logica di business -------------------------------------------- */
                        File directory = new File(dirName);
                        if ( !directory.exists() && !directory.isDirectory()) {
                            outSock.writeUTF("a"); // messaggio di errore
                            System.out.println("Directory \"" + dirName + "\" non esiste o non è una directory");
                        } else {
                            System.out.println("Invio directory \"" + dirName + "\"");
                            outSock.writeUTF("p"); // messaggio di successo
                            File[] files = directory.listFiles();
                            for (int i = 0; i < files.length; i++) {
                                File file = files[i];
                                System.out.println("Trovato file con nome: " + file.getName());
                                
                                numeroByte = file.length();
                                if (numeroByte >= soglia){
                                    // 1. invio il nome
                                    outSock.writeUTF(file.getName());
                                    
                                    // 2. invio la lunghezza
                                    outSock.writeLong(numeroByte);

                                    // trasferisce il file in linea
                                    src_stream = new DataInputStream(new FileInputStream(file.getAbsolutePath()));
                                    cont = 0;
                                    try {
                                        // fin quando ho letto il numero di byte ...
                                        while (cont < numeroByte) {
                                            read_bytes = src_stream.read(buffer);
                                            outSock.write(buffer, 0, read_bytes);
                                            cont += read_bytes;
                                        }
                                        outSock.flush();
                                        System.out.println("Byte trasferiti: " + cont);
                                    } catch (EOFException e) {
                                        System.out.println("Problemi, i seguenti: ");
                                        e.printStackTrace();
                                    }
                                } else {
                                    System.out.println("Dim. inferiore alla soglia");
                                }
                            }
                            outSock.writeUTF("FINE"); // protocollo per indicare la fine
                            System.out.println("Cartella inviata con successo");
                        }

                        /* FINE INVIA UNA DIRECTORY =============================== SNIPPET */
                    
                    } 
                    /* FINE RICEVI FILE SOPRA SOGLIA ================================================ */
                    else {                            // SERVIZIO NON PRESENTE
                        System.out.println("Servizio non presente");
                        continue;
                    }

                } /* ricevuto EOF */

                System.out.println("Ho terminato");

            } catch (EOFException eof) {
                clientSocket.close();
                System.out.println("Server: inviato EOF, termino il thread " + Thread.currentThread().getName());
            } catch (SocketTimeoutException ste) {
                System.out.println("Timeout scattato: ");
                ste.printStackTrace();
                clientSocket.close();
            } catch (Exception e) {
                System.out.println("Problemi, i seguenti : ");
                e.printStackTrace();
                System.out.println("Chiudo ed esco...");
                clientSocket.close();
        }
        } catch (IOException e){
            System.err.println("Errore nella chiusura del socket: " + e.getMessage());
            System.exit(1);
        }
    }
}

public class ServerTCP {

    public static void main(String[] args) {
        int port = -1;

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
