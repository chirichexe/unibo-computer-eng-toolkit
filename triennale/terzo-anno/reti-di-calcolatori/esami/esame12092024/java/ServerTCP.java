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
                String matricola;
                String nome;
                String cognome;
                String input;
                
                int risultato = 0;
                String[] nSucc = new String[50];
                
                // ---- SWITCH SERVIZI ----
                while ((servizio = inSock.readUTF()) != null) {
                    
                    if (servizio.equals("1")) {         // SERVIZIO 1
                        matricola = inSock.readUTF();
                        nome = inSock.readUTF();
                        cognome = inSock.readUTF();
                        
                        risultato = ServerTCP.esame.iscrivi_studente_appello(matricola, nome, cognome);
                        ServerTCP.esame.stampa();

                        outSock.writeInt(risultato);
                        
                    } else if (servizio.equals("2")){   // SERVIZIO 2

                        input = inSock.readUTF();

                        nSucc = ServerTCP.esame.carica_voti(input);

                        for (String string : nSucc) {
                            if (string != null){
                                outSock.writeUTF(string);
                            }
                        }
                        
                        outSock.writeUTF("FINE");   
                    
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

    public static Esame esame;

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

        esame = new Esame();

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
