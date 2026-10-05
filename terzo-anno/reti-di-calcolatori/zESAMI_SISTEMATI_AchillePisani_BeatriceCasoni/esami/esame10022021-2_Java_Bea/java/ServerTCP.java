/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.io.*;
import java.net.*;
import Elemento;

class ClientHandler extends Thread {
    private Socket clientSocket = null;
    private static int DIM_BUFF = 4096;

    public ClientHandler(Socket clientSocket) {
        this.clientSocket = clientSocket;
    }

    public void run() {
        System.out.println("Attivazione figlio: " + Thread.currentThread().getName());

        /* CREAZIONE STREAM INPUT/OUTPUT */
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
        String inputId, inputModello;

        /* ESECUZIONE PROGRAMMA ===================================================== */
        try {
            try {
                /* Richieste servizio fino a EOF ------------------------------------- */
                while ((servizio = inSock.readUTF()) != null) {

                    // Servizio 1: Costo Noleggio
                    if (servizio.equals("1")) {
                        inputId = inSock.readUTF();
                        risultato = 0;

                        // Cerca il prodotto con l'ID richiesto
                        for (i = 0; i < 10; i++) {
                            if (ServerTCP.t[i].getId().equals(inputId)) {
                                risultato = ServerTCP.t[i].getCostoG() * ServerTCP.t[i].getGiorni();
                                System.out.println("Trovato");
                                break;
                            }
                        }

                        outSock.writeInt(risultato);

                    } 
                    // Servizio 2: Ricevi Elementi per Modello
                    else if (servizio.equals("2")) {
                        inputModello = inSock.readUTF();

                        // Ciclo per inviare tutti gli elementi che corrispondono al modello
                        //int i2 = 0;
                        for (i = 0; i < 10; i++) {
                            if (ServerTCP.t[i].getModello().equals(inputModello)) {

                                Elemento elemento = ServerTCP.t[i];
                                File fotoFile = new File(elemento.getNomeFileFoto());

                                if (!fotoFile.exists() || !fotoFile.isFile()) {
                                    outSock.writeUTF("a");  // errore, il file non esiste
                                    System.out.println("File \"" + fotoFile.getName() + "\" non esiste o non è un file.");
                                } else {
                                    outSock.writeUTF("p");  // file trovato, invio i dati

                                    // 1. Invia il nome del file
                                    outSock.writeUTF(fotoFile.getName());
                                    
                                    // 2. Invia la lunghezza del file
                                    long numeroByte = fotoFile.length();
                                    outSock.writeLong(numeroByte);

                                    // 3. Invia il contenuto del file
                                    byte[] buffer = new byte[DIM_BUFF];
                                    int cont = 0;
                                    int readBytes;
                                    try (DataInputStream src_stream = new DataInputStream(new FileInputStream(fotoFile))) {
                                        while (cont < numeroByte) {
                                            readBytes = src_stream.read(buffer);
                                            outSock.write(buffer, 0, readBytes);
                                            cont += readBytes;
                                        }
                                        outSock.flush();
                                        System.out.println("Byte trasferiti: " + cont);
                                    }

                                    // 4. Invia i dati dell'elemento
                                    outSock.writeUTF(elemento.getId());
                                    outSock.writeUTF(elemento.getData());
                                    outSock.writeInt(elemento.getGiorni());
                                    outSock.writeUTF(elemento.getModello());
                                    outSock.writeInt(elemento.getCostoG());
                                    outSock.writeUTF(elemento.getNomeFileFoto());

                                    //i2++;
                                }
                            }
                        }

                        // Fine della lista
                        outSock.writeUTF("END");
                        System.out.println("Cartella inviata con successo");
                    } 
                    // Se il servizio non è riconosciuto
                    else {
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
                System.out.println("Problemi, i seguenti: ");
                e.printStackTrace();
                System.out.println("Chiudo ed esco...");
                clientSocket.close();
            }
        } catch (IOException e) {
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
            for (i = 0; i < 10; i++) {
                t[i] = new Elemento();
            }

            t[0].setId("ID1");
            t[0].setData("12/12/2024");
            t[0].setGiorni(3);
            t[0].setCostoG(5);
            t[0].setModello("volpi");
            t[0].setNomeFileFoto("volpi.jpg");

            t[1].setId("ID2");
            t[1].setData("12/12/2023");
            t[1].setGiorni(2);
            t[1].setCostoG(3);
            t[1].setModello("vsstpi");
            t[1].setNomeFileFoto("vsstpi.jpg");

            t[2].setId("ID3");
            t[2].setData("12/12/2020");
            t[2].setGiorni(8);
            t[2].setCostoG(9);
            t[2].setModello("arrvolpi");
            t[2].setNomeFileFoto("arrvolpi.jpg");

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
