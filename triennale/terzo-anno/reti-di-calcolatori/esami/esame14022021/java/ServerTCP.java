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
        String servizio;
        int risultato, i;
        String inputId, newId;

        /* ESECUZIONE PROGRAMMA ===================================================== */
        try{ 
            try {
            
                
                /* Richieste servizio fino a EOF ------------------------------------- */
                while ((servizio = inSock.readUTF()) != null) {
                    
                    /* AGGIORNA CARTA ===================================================== */

                    if (servizio.equals("1")) {
                        inputId = inSock.readUTF();
                        newId = inSock.readUTF();
                        risultato = 0;

                        for ( i = 0; i < 10; i++ ){
                            if ( ServerTCP.t[i].getId().equals(inputId)){
                                ServerTCP.t[i].setId(newId);
                                risultato = 1;
                                System.out.println("Trovato");
                                break;
                            }
                        }
                        
                        outSock.writeInt(risultato);
                    } 
                    /* FINE AGGIORNA CARTA ================================================ */
                    /* --------------------------------------------------------------- */
                    /* SCARICA FOTO ===================================================== */
                    else if (servizio.equals("2")){
                        inputId = inSock.readUTF();
                        
                        /* INVIA UNA DIRECTORY =================================== SNIPPET */
                        // Variabili (da spostare sopra) -----------------------------------
                        long numeroByte;
                        byte[] buffer = new byte[DIM_BUFF];
                        int cont = 0;
                        int read_bytes = 0;
                        DataInputStream src_stream = null;
                        File[] files;
                        File file, directory;
                        String dirName;

                        // Algoritmo --------------------------------------------------------
                        
                        dirName = inputId + "_img/";
                        directory = new File(dirName);
                        if ( !directory.exists() && !directory.isDirectory()) {
                            outSock.writeUTF("a"); // messaggio di errore
                            System.out.println("Directory \"" + dirName + "\" non esiste o non è una directory");
                        } else {
                            System.out.println("Invio directory \"" + dirName + "\"");
                            outSock.writeUTF("p"); // messaggio di successo
                            files = directory.listFiles();
                            for (i = 0; i < files.length; i++) {
                                file = files[i];
                                System.out.println("Trovato file con nome: " + file.getName());
                                
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
                                    continue;
                                }
                            }
                            outSock.writeUTF("END"); // protocollo per indicare la fine
                            System.out.println("Cartella inviata con successo");
                        }

                        /* FINE INVIA UNA DIRECTORY =============================== SNIPPET */
                    
                    } 
                    /* FINE SCARICA FOTO ================================================ */
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
    private static final int N = 10;
    public static final Elemento[] t = new Elemento[N];

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

            // Inizializzo i dati
            for (  i = 0; i < 10; i++ ){
                t[i] = new Elemento();
            }

            t[0].setId("ID1");
            t[0].setCartaId("12345");
            t[0].setMarca("brand1");
            t[0].setImg("ID1_img/");

            t[1].setId("ID2");
            t[1].setCartaId("12346");
            t[1].setMarca("brand2");
            t[1].setImg("ID2_img/");

            t[1].setId("ID3");
            t[1].setMarca("brand3");
            t[1].setImg("ID3_img/");

            // Dati inizializzati

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
