//CHIRICHELLA DAVIDE 0001071414

import java.io.*;
import java.net.*;

class ClientHandler extends Thread {
    private Socket clientSocket = null;
    private Elemento[][] elementi = null;

    private static int DIM_BUFF = 4096;
    private static int M = 4;
    private static int N = 4;


    public ClientHandler(Socket clientSocket, Elemento[][] elementi) {
        this.clientSocket = clientSocket;
        this.elementi = elementi;
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
        int risultato = 0, i, j;
        String matricola = null;
        String dirName = null;
        String line = null; 

        /* ESECUZIONE PROGRAMMA ===================================================== */
        try{ 
            try {
                
                /* Richieste servizio fino a EOF ------------------------------------- */
                while ((servizio = inSock.readUTF()) != null) {
                    
                    /* AGGIUNGI PRENOTAZIONE ===================================================== */

                    if (servizio.equals("1")) {
                        matricola = inSock.readUTF();
                        
                        int riga = -1;
                        int colonna = -1;

                        for (i = 0; i < N ; i++) {
                            line = "";
                            for (j = 0; j < M ; j++) {
                                line += elementi[i][j].toString();
                            }
                            System.out.println(line);
                        }

                        // Logica di business -------------------------------------------

                        for (i = 0; i < N; i++) {
                            for (j = 0; j < M - 1 ; j++) {
                                // controllo se ho trovato la mia matricola
                                if ( elementi[i][j].getMatricola().equals(matricola) && elementi[i][j+1].isLibera() ) {

                                    riga = i;
                                    colonna = j + 1;
                                    elementi[riga][colonna].setMatricola(matricola);
                                    elementi[riga][colonna].setDirectory(matricola + "_img");
                                    break;

                                }
                            }
                        }

                        outSock.writeInt(riga);
                        outSock.writeInt(colonna);

                    } 
                    /* FINE AGGIUNGI PRENOTAZIONE ================================================ */
                    /* --------------------------------------------------------------- */
                    /* TRASFERISCI BADGE ===================================================== */
                    else if (servizio.equals("2")){
                        dirName = inSock.readUTF();
                        
                        /* INVIA UNA DIRECTORY =================================== SNIPPET */
                        // Variabili (da spostare sopra) -----------------------------------
                        long num_bytes;
                        byte[] buffer = null;
                        int bytes_count = 0;
                        int read_bytes = 0;
                        DataInputStream src_stream = null;
                        File[] files = null;
                        File file = null;

                        // Algoritmo --------------------------------------------------------
                        buffer = new byte[DIM_BUFF];

                        File directory = new File(dirName);
                        if ( !directory.exists() && !directory.isDirectory()) {
                            outSock.writeInt(-1); // status code di assenza directory
                            System.out.println("Directory \"" + dirName + "\" non esiste o non è una directory");
                        } else {
                            System.out.println("Invio directory \"" + dirName + "\"");
                            outSock.writeInt(0); // status code di successo

                            files = directory.listFiles();
                            for (i = 0; i < files.length; i++) {
                                file = files[i];
                                if (file.isFile()){
                                    System.out.println("Trovato file con nome: " + file.getName());
                                    num_bytes = file.length();
                                    
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
                            outSock.writeUTF("END");
                            System.out.println("Cartella inviata con successo");
                            
                        }

                        /* FINE INVIA UNA DIRECTORY =============================== SNIPPET */                    
                    } 
                    /* FINE TRASFERISCI BADGE ================================================ */
                    else {                            // SERVIZIO NON PRESENTE
                        System.out.println("Servizio non presente");
                    }

                } /* ricevuto EOF */

                System.out.println("Ho terminato, chiudo il Thread");

            } catch (EOFException eof) {
                clientSocket.close();
                System.out.println("Server: inviato EOF, termino il thread " + Thread.currentThread().getName());
                Thread.currentThread().interrupt();

            } catch (SocketTimeoutException ste) {
                System.out.println("Timeout scattato: ");
                ste.printStackTrace();
                clientSocket.close();
                Thread.currentThread().interrupt();

            } catch (Exception e) {
                System.out.println("Problemi, i seguenti : ");
                e.printStackTrace();
                System.out.println("Chiudo ed esco...");
                clientSocket.close();
                Thread.currentThread().interrupt();
            }
        } catch (IOException e){
            System.err.println("Errore nella socket: " + e.getMessage());
            Thread.currentThread().interrupt();
        }
    }
}

public class ServerTCP {

    private static int M = 4;
    private static int N = 4;

    public static void main(String[] args) {
        int i,j , port = -1;

        /* Inizializzazione struttura dati */

        Elemento[][] elementi = new Elemento[N][M];

        for (i = 0; i < N; i++) {
            for (j = 0; j < M ; j++) {
                elementi[i][j] = new Elemento();
            }        
        }

        elementi[0][0].setMatricola("DATO11");
        elementi[0][0].setDirectory("DATO11_img");

        elementi[0][1].setMatricola("DATO21");
        elementi[0][1].setDirectory("DATO21_img");

        elementi[1][1].setMatricola("DATO12");
        elementi[1][1].setDirectory("DATO12_img");

        elementi[2][0].setMatricola("DATO13");
        elementi[2][0].setDirectory("DATO13_img");


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

                    new ClientHandler(clientSocket, elementi).start();
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
