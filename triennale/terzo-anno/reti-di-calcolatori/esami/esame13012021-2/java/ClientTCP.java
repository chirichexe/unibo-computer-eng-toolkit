/*
/// Author: Davide Chirichella
/// Matricola: 0001071414
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
        
        /* bytes_countrollo argomenti --------------------------------------------------- */
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
        
        /* Creazione stream Input/Output ----------------------------------------- */
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
        
        /* Variabili ------------------------------------------------------------ */
        String dirName = null;
        String charString = null;
        String nOccString = null;
        int nOcc = -1;
        int risultato = -1;
        
        /* Servizi fino ad EOF --------------------------------------------------- */
        System.out.println("Inserisci il servizio: 1= CONTA LINEE, 2= TRASFERISCI FILE BIN");
        while ((servizio = stdIn.readLine()) != null) {
            
            /* CONTA LINEE ===================================================== */
            
            if (servizio.equals("1")) {
                System.out.println("Inserisci nome directory:");
                dirName = stdIn.readLine();

                System.out.println("Inserisci numero occorrenze:");
                nOccString = stdIn.readLine();
                try {
                    nOcc = Integer.parseInt(nOccString);
                } catch ( NumberFormatException nfe ){
                    System.out.println("Numero non valido");
                    continue;
                }

                System.out.println("Inserisci carattere:");
                charString = stdIn.readLine();

                outSock.writeUTF(servizio);
                outSock.writeUTF(dirName);
                outSock.writeChar(charString.charAt(0));
                outSock.writeInt(nOcc);
                
                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato); 
            }

            /* FINE CONTA LINEE ================================================ */
            /* --------------------------------------------------------------- */
            /* TRASFERISCI FILE BIN ===================================================== */

            else if (servizio.equals("2")){
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome directory:");
                dirName = stdIn.readLine();
                outSock.writeUTF(dirName);
                
                /* RICEVI UNA DIRECTORY ================================== SNIPPET */
                // Variabili necessarie (da spostare --------------------------------
                byte[] buffer = new byte[DIM_BUFF];
                int bytes_count = 0;
                int read_bytes = 0;
                int bytes_left;
                DataOutputStream dest_stream = null;
                int dir_status;

                String file_name = null;
                long num_bytes;
                File file = null;
                FileOutputStream outfile = null;

                dir_status = inSock.readInt();

                if ( dir_status < 0) {
                    System.out.println("Directory richiesta non esistente lato servitore. Codice: " +  dir_status);

                } else{
                    System.out.println("Directory richiesta esistente lato servitore: " +  dir_status);

                    // Ricevo nome
                    while (!(file_name = inSock.readUTF()).equals("END")) {
    
                        file = new File(file_name); // se devo controllare se esiste già, non necessario ora
                        
                        // Ricevo lunghezza
                        num_bytes = inSock.readLong();
    
                        System.out.println("Ricevuto file " + file_name + " di " + num_bytes + " byte");
                        outfile = new FileOutputStream(file_name);
    
                        // Ricevo il contenuto del file
                        dest_stream = new DataOutputStream(outfile);
                        try {
                            bytes_count = 0;
                            // fin quando ho letto il numero di byte ...
                            while (bytes_count < num_bytes) {
                                bytes_left = (int) num_bytes - bytes_count;
                                read_bytes = inSock.read(buffer, 0, bytes_left < buffer.length ? bytes_left : buffer.length );
                                dest_stream.write(buffer, 0, read_bytes);
                                bytes_count += read_bytes;
                            }                        
                            dest_stream.flush();
                            System.out.println("Byte trasferiti: " + bytes_count);
    
                        } catch (EOFException e) {
                            System.out.println("Problemi, i seguenti: ");
                            e.printStackTrace();
                            System.exit(1);
                        }
                    }
                }

                /* FINE RICEVI UNA DIRECTORY ============================== SNIPPET */

            }
            
            /* FINE TRASFERISCI FILE BIN ================================================ */
                
            else {
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1= CONTA LINEE, 2= TRASFERISCI FILE BIN");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
