/*
 * Nome Cognome - Matricola 0000000000
 *
 * Reti di Calcolatori T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import java.net.*;
import java.io.*;

public class ClientTCP {

    private static final int DIM_BUFF = 4096;

    public static void main(String[] args) throws IOException {
        InetAddress addr = null;
        int port = -1;

        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        String servizio = null;

        // Controllo argomenti
        try {
            if (args.length == 2) {
                addr = InetAddress.getByName(args[0]);
                port = Integer.parseInt(args[1]);
                if (port < 1024 || port > 65535) {
                    System.out.println("Usage: java client serverAddr serverPort");
                    System.exit(1);
                }
            } else {
                System.out.println("Usage: java client serverAddr serverPort");
                System.exit(1);
            }
        } catch (Exception e) {
            System.out.println("Errore durante il parsing degli argomenti:");
            e.printStackTrace();
            System.exit(2);
        }

        // Creazione socket e stream
        Socket socket = null;
        DataInputStream inSock = null;
        DataOutputStream outSock = null;

        try {
            socket = new Socket(addr, port);
            socket.setSoTimeout(30000);
            System.out.println("Socket creata: " + socket);
            inSock = new DataInputStream(socket.getInputStream());
            outSock = new DataOutputStream(socket.getOutputStream());
        } catch (IOException ioe) {
            System.out.println("Errore nella creazione degli stream socket:");
            ioe.printStackTrace();
            System.exit(1);
        }

        // Variabili utili
        String inputId = null;
        String inputModello = null;
        int risultato;
        byte[] buffer = new byte[DIM_BUFF];
        int read_bytes;
        long numeroByte;
        String nomeFileRicevuto;
        FileOutputStream outfileRicevuto;

        System.out.println("Inserisci il servizio: 1 = Costo Noleggio, 2 = Ricevi Elementi per Modello");
        while ((servizio = stdIn.readLine()) != null) {

            /* Servizio 1 - Costo noleggio */
            if (servizio.equals("1")) {
                outSock.writeUTF(servizio);

                System.out.println("Inserisci ID dell'elemento:");
                inputId = stdIn.readLine();
                outSock.writeUTF(inputId);

                risultato = inSock.readInt();
                System.out.println("Costo totale del noleggio: " + risultato);
            }

            /* Servizio 2 - Ricevi elementi per modello */
            else if (servizio.equals("2")) {
                outSock.writeUTF(servizio);

                System.out.println("Inserisci modello:");
                inputModello = stdIn.readLine();
                outSock.writeUTF(inputModello);

                while (true) {
                    String stato = inSock.readUTF();  // "p" (ok), "a" (errore), "END" (fine)

                    if (stato.equals("END")) {
                        System.out.println("Fine ricezione elementi.");
                        break;
                    }

                    if (stato.equals("a")) {
                        System.out.println("Errore: file non trovato o non valido.");
                        continue;
                    }

                    if (stato.equals("p")) {
                        // Ricevi file foto
                        nomeFileRicevuto = inSock.readUTF();
                        numeroByte = inSock.readLong();

                        outfileRicevuto = new FileOutputStream(nomeFileRicevuto);
                        DataOutputStream dest_stream = new DataOutputStream(outfileRicevuto);

                        int cont = 0;
                        while (cont < numeroByte) {
                            read_bytes = inSock.read(buffer, 0, (int)Math.min(DIM_BUFF, numeroByte - cont));
                            dest_stream.write(buffer, 0, read_bytes);
                            cont += read_bytes;
                        }
                        dest_stream.flush();
                        dest_stream.close();
                        System.out.println("Foto salvata: " + nomeFileRicevuto);

                        // Ricevi attributi dell'elemento
                        String id = inSock.readUTF();
                        String data = inSock.readUTF();
                        int giorni = inSock.readInt();
                        String modello = inSock.readUTF();
                        int costoG = inSock.readInt();
                        String nomeFileFoto = inSock.readUTF();

                        // Stampa informazioni
                        System.out.println("Elemento ricevuto:");
                        System.out.println("  ID: " + id);
                        System.out.println("  Data: " + data);
                        System.out.println("  Giorni: " + giorni);
                        System.out.println("  Modello: " + modello);
                        System.out.println("  Costo Giornaliero: " + costoG);
                        System.out.println("  Nome File Foto: " + nomeFileFoto);
                        System.out.println("-----------------------------------");
                    }
                }
            }

            else {
                System.out.println("Servizio non riconosciuto.");
            }

            System.out.println("Inserisci il servizio: 1 = Costo Noleggio, 2 = Ricevi Elementi per Modello");
        }

        System.out.println("Client: termino.");
        socket.close();
    }
}
