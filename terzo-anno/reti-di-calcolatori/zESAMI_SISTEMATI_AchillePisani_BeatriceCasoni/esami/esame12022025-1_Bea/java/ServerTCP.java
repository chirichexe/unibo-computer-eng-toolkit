/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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
                int occorrNumnome = 0;
                int numCaratteri = 0;
                int numNumeriche = 0;
                
                // ---- SWITCH SERVIZI ----
                while ((servizio = inSock.readUTF()) != null) {
                    
                    if (servizio.equals("1")) {         // SERVIZIO 1
                        dirName = inSock.readUTF();     // prende nome directory
                        numOccRichieste = inSock.readInt(); // prende num occorrenze da confrontare con caratteri e numerici
                        
                        // ---- scorre una directory -----
                        File directory = new File(dirName);
                        if (directory.exists() && directory.isDirectory()) {
                            File[] files = directory.listFiles();
                            for (int i = 0; i < files.length; i++) {
                                File file = files[i];
                                if (file.isFile()) {
                                    System.out.println("Trovato file: " + file.getName());
                                    
                                    if(!file.getName().endsWith(".txt"))
                                        continue;

                                    occorrNumnome = 0;
                                    String numeri = "0123456789"; // come stringa normale
                                    String fileName = file.getName();
                                    for (int j = 0; j < fileName.length(); j++) {
                                        if (numeri.contains(String.valueOf(fileName.charAt(j)))) {
                                            occorrNumnome++;
                                        }
                                    }


                                    if(occorrNumnome < 2)
                                        continue;

                                    // ---- legge le righe dei file -----
                                    try (FileInputStream fis = new FileInputStream(file);
                                    InputStreamReader isr = new InputStreamReader(fis);
                                    BufferedReader br = new BufferedReader(isr)) {
                                        
                                        // opz1: leggo tutto il contenuto
                                        /*
                                        StringBuilder fileContent = new StringBuilder();
                                        int character;
                                        
                                        while ((character = br.read()) != -1) { 
                                            fileContent.append((char) character);
                                        }
                                        System.out.println("Contenuto del file:\n" + fileContent.toString());
                                        */
                                        // opz2: leggo riga per riga
                                        String line;

                                        while ((line = br.readLine()) != null) { 
                                            numCaratteri = 0;
                                            numNumeriche = 0;
                                            for(int j = 0; j < line.length(); j++){
                                                char c = line.charAt(j);
                                                if (Character.isLetter(c)) {
                                                    numCaratteri++;
                                                }
                                                if(numeri.contains(String.valueOf(c)))
                                                    numNumeriche++;

                                            }

                                            if(numCaratteri >= numOccRichieste && numNumeriche >= numOccRichieste )
                                                risultato++;

                                          
                                            System.out.println("Riga letta: " + line);
                                        }
                                        System.out.println("Numero righe lette che soddisfano criteri: " + risultato);
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
                        /*nviare tutti i file binari della directory principale + tutti i file .txt 
                        contenuti nei sottodirettori di primo livello */

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

                                // ---- Caso 1: FILE BINARI nella directory principale ----
                                if (file.isFile() && !file.getName().endsWith(".txt")){
                                    System.out.println("File binario con nome: " + file.getName());

                                    // 1. invio il nome
                                    outSock.writeUTF(file.getName());
                                    numeroByte = file.length();

                                    // 2. invio la lunghezza
                                    outSock.writeLong(numeroByte);

                                    // 3. trasferisce il file in linea
                                    src_stream = new DataInputStream(new FileInputStream(file.getAbsolutePath()));
                                    cont = 0;
                                    try {
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
                                    src_stream.close();

                                }else if (file.isDirectory()){ // ---- Caso 2: FILE .TXT nei sottodirectory di primo livello ----
                                    File[] subFiles = file.listFiles();
                                    if (subFiles == null) continue;

                                    for (int j = 0; j < subFiles.length; j++) {
                                        File subFile = subFiles[j];
                                        if (subFile.isFile() && subFile.getName().endsWith(".txt")) {
                                            System.out.println("File .txt trovato in sottodir: " + subFile.getAbsolutePath());

                                            // 1. invio il nome (con prefisso opzionale se vuoi evitare conflitti)
                                            outSock.writeUTF(subFile.getName());
                                            numeroByte = subFile.length();

                                            // 2. invio la lunghezza
                                            outSock.writeLong(numeroByte);

                                            // 3. trasferisce il file in linea
                                            src_stream = new DataInputStream(new FileInputStream(subFile.getAbsolutePath()));
                                            cont = 0;
                                            try {
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
                                            src_stream.close();
                                        }
                                    }
                                }
                            }
                        } else {
                            outSock.writeUTF("errore"); // messaggio di errore
                            System.err.println("Errore: Directory non esiste o non è una directory");
                        }

                        outSock.writeUTF("END"); // protocollo
                        System.out.println("Cartella inviata con successo");
                        // ---- fine: invia una directory -----
                    }else 
                        { // SERVIZIO NON PRESENTE
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