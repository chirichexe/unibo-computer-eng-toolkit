import java.net.*;
import java.io.*;

public class ClientTCP {

    private static final int BUFFER_SIZE = 4096;
    public static void main(String[] args) throws IOException {
        InetAddress addr = null;
        int port = -1;

        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        String dirName = null;
        String servizio = null;
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
        System.out.println("Inserisci il servizio: 1=conta directory, 2=ricevi directory");
        
        // ---- SWITCH SERVIZI ----
        while ((servizio = stdIn.readLine()) != null) {
            
            if (servizio.equals("1")) {         // SERVIZIO 1
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome directory:");
                dirName = stdIn.readLine();
                outSock.writeUTF(dirName);
                
                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato);
                
                
            } else if (servizio.equals("2")){   // SERVIZIO 2
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome directory:");
                dirName = stdIn.readLine();
                outSock.writeUTF(dirName);
                
                // ---- riceve una directory -----
                // variabili necessarie (da spostare)
                byte[] buffer = new byte[BUFFER_SIZE];
                int cont = 0;
                int read_bytes = 0;
                DataOutputStream dest_stream = null;
                
                String nomeFileRicevuto;
                long numeroByte;
                File fileRicevuto;
                FileOutputStream outfileRicevuto;

                // 1. leggo nome file
                while (!(nomeFileRicevuto = inSock.readUTF()).equals("END")) { // protocollo
                    fileRicevuto = new File(nomeFileRicevuto); // se devo controllare se esiste già, non necessario ora
                    
                    // 2. leggo dimensione file
                    numeroByte = inSock.readLong();

                    System.out.println("Ricevuto file " + nomeFileRicevuto + " di " + numeroByte + " byte");
                    outfileRicevuto = new FileOutputStream(nomeFileRicevuto);

                    // ricevo il file in linea
                    dest_stream = new DataOutputStream(outfileRicevuto);
                    try {
                        cont = 0;
                        // fin quando ho letto il numero di byte ...
                        while (cont < numeroByte) {
                            read_bytes = inSock.read(buffer, 0, Math.min(buffer.length, (int)(numeroByte - cont)));
                            dest_stream.write(buffer, 0, read_bytes);
                            cont += read_bytes;
                        }                        
                        dest_stream.flush();
                        System.out.println("Byte trasferiti: " + cont);

                    } catch (EOFException e) {
                        System.out.println("Problemi, i seguenti: ");
                        e.printStackTrace();
                    }

                    outfileRicevuto.close();
                }

                // ---- fine: riceve una directory -----
                
            } else {                            // SERVIZIO SCONOSCIUTO
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1=conta directory, 2=ricevi directory");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
