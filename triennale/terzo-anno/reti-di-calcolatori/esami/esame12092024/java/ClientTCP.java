import java.net.*;
import java.io.*;

public class ClientTCP {

    private static final int BUFFER_SIZE = 4096;
    public static void main(String[] args) throws IOException {
        InetAddress addr = null;
        int port = -1;

        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        String matricola = null;
        String nome = null;
        String cognome = null;
        String servizio = null;
        String input = null;
        String senzaSuccesso = null;
        int risultato;

        /* Controllo argomenti */
        try {
            if (args.length == 2) {
                addr = InetAddress.getByName(args[0]);
                port = Integer.parseInt(args[1]);
                if (port < 1024 || port > 65535) {
                    System.out.println("Usage: java client serverAddr serverPort");
                    System.exit(1);
                }
            } else {
                System.out.println("Usage: java client serverAddr serverPort ");
                System.exit(1);
            }
        } catch (Exception e) {
            System.out.println("Problemi, i seguenti: ");
            e.printStackTrace();
            System.exit(2);
        }

        /* Creazione stream Input/Output */
        Socket socket = null;
        DataInputStream inSock = null;
        DataOutputStream outSock = null;
        
        try {
            socket = new Socket(addr, port);
            socket.setSoTimeout(30000);
            System.out.println("Creata la socket: " + socket);
            inSock = new DataInputStream(socket.getInputStream());
            outSock = new DataOutputStream(socket.getOutputStream());
        } catch (IOException ioe) {
            System.out.println("Problemi nella creazione degli stream su socket: ");
            ioe.printStackTrace();
            System.exit(1);
        }
        
        /* Esecuzione programma */
        System.out.println("Inserisci il servizio: 1=aggiungi matricola, 2=carica voti");
        
        // ---- SWITCH SERVIZI ----
        while ((servizio = stdIn.readLine()) != null) {
            
            if (servizio.equals("1")) {         // SERVIZIO 1
                outSock.writeUTF(servizio);
                System.out.println("Inserisci matricola:");
                matricola = stdIn.readLine();
                outSock.writeUTF(matricola);

                System.out.println("Inserisci nome:");
                nome = stdIn.readLine();
                outSock.writeUTF(nome);

                System.out.println("Inserisci cognome:");
                cognome = stdIn.readLine();
                outSock.writeUTF(cognome);
                
                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato);
                
                
            } else if (servizio.equals("2")){   // SERVIZIO 2
                outSock.writeUTF(servizio);
                System.out.println("Inserisci input (pattern matricola,voto:matricola,voto: ... ):");
                input = stdIn.readLine();
                outSock.writeUTF(input);
                
                System.out.println("Errore riscontrato per matricole:");
                while ( !(senzaSuccesso = inSock.readUTF()).equals("FINE") ){
                    System.out.println("- " + senzaSuccesso);
                }                
            } else {                            // SERVIZIO SCONOSCIUTO
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1=aggiungi matricola, 2=carica voti");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
