import java.io.*;
import java.net.*;

class ClientHandler extends Thread {
    private Socket clientSocket = null;
    private static int BUFFER_SIZE = 4096;

    public ClientHandler(Socket clientSocket) {
        this.clientSocket = clientSocket;
    }

    public void run() {
        System.out.println("Attivazione figlio: " + Thread.currentThread().getName());

        /* Creazione stream Input/Output */
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

        /* Esecuzione programma */
        try{ 
            try {
            
                // variabili per il problema
                String servizio;
                String dirName;
                
                int numOccRichieste = 1;
                int risultato = 0;
                
                // ---- SWITCH SERVIZI ----
                while ((servizio = inSock.readUTF()) != null) {
                    
                    if (servizio.equals("1")) {         // SERVIZIO 1
                        dirName = inSock.readUTF();     // prende nome directory
                        
                        // ---- scorre una directory -----
                        File directory = new File(dirName);
                        if (directory.exists() && directory.isDirectory()) {
                            File[] files = directory.listFiles();
                            for (int i = 0; i < files.length; i++) {
                                File file = files[i];
                                if (file.isFile()) {
                                    System.out.println("Trovato file: " + file.getName());
                                    
                                    // ---- legge le righe dei file -----
                                    try (FileInputStream fis = new FileInputStream(file);
                                    InputStreamReader isr = new InputStreamReader(fis);
                                    BufferedReader br = new BufferedReader(isr)) {
                                        
                                        // opz1: leggo tutto il contenuto
                                        StringBuilder fileContent = new StringBuilder();
                                        int character;
                                        
                                        while ((character = br.read()) != -1) { 
                                            fileContent.append((char) character);
                                        }
                                        System.out.println("Contenuto del file:\n" + fileContent.toString());
                                        // opz2: leggo riga per riga
                                        String line;
                                        while ((line = br.readLine()) != null) { 
                                            System.out.println("Riga letta: " + line);
                                        }
                                        // opz3: leggo riga carattere per carattere
                                        /*
                                        StringBuilder currentLine = new StringBuilder();
                                        int character;
                                        
                                        // --- logica di business sulle righe ----
                                        while ((character = br.read()) >= 0) { 
                                            System.out.println((char) character);
                                            if (character == '\n') {
                                                currentLine.setLength(0);
                                                System.out.println(currentLine);
                                            } else {
                                                currentLine.append( (char) character);
                                            }
                                        }
                                        
                                        if (currentLine.length() > 0) {
                                            System.out.println(currentLine.toString());
                                        }
                                        */
                                        // --- fine logica di business sulle righe ----
                                        
                                    } catch (IOException e) {
                                        System.err.println("Errore durante la lettura del file: " + e.getMessage());
                                    }
                                    // ---- fine: legge le righe dei file -----
                                }
                            }
                        } else {
                            outSock.writeUTF("errore"); // messaggio di errore
                            System.out.println("Errore: Directory non esiste o non è una directory");
                        }
                        // ---- scorre una directory: fine -----
                        
                        outSock.writeInt(risultato);
                        
                    } else if (servizio.equals("2")){   // SERVIZIO 2
                        dirName = inSock.readUTF();     // prende nome directory
                        
                        // ---- invia una directory -----
                        // variabili necessarie (da spostare)
                        long numeroByte;

                        byte[] buffer = new byte[BUFFER_SIZE];
                        int cont = 0;
                        int read_bytes = 0;

                        DataInputStream src_stream = null;

                        // logica di business
                        File directory = new File(dirName);
                        if (directory.exists() && directory.isDirectory()) {
                            File[] files = directory.listFiles();
                            for (int i = 0; i < files.length; i++) {
                                File file = files[i];
                                System.out.println("File con nome: " + file.getName());
                                
                                // 1. invio il nome
                                outSock.writeUTF(file.getName());
                                numeroByte = file.length();
                                
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
                            }
                        } else {
                            outSock.writeUTF("errore"); // messaggio di errore
                            System.err.println("Errore: Directory non esiste o non è una directory");
                        }
                        outSock.writeUTF("END"); // protocollo
                        System.out.println("Cartella inviata con successo");
                        // ---- fine: invia una directory -----

                        outSock.writeInt(risultato);
                    
                    } else {                            // SERVIZIO NON PRESENTE
                        System.out.println("Servizio non presente");
                        continue;
                    }   
                }
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
