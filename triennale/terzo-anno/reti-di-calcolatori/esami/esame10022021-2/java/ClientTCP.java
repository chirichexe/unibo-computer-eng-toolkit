//CHIRICHELLA DAVIDE 0001071414

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
        String modello = null;  
        String id = null;
        int risultato;
        
        /* Servizi fino ad EOF --------------------------------------------------- */
        System.out.println("Inserisci il servizio: 1= SERVIZIO1, 2= SERVIZIO2");    
        while ((servizio = stdIn.readLine()) != null) {
            
            /* SERVIZIO1 ===================================================== */
            
            if (servizio.equals("1")) {
                outSock.writeUTF(servizio);
                System.out.println("Inserisci id:");
                id = stdIn.readLine();
                outSock.writeUTF(id);
                
                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato); 
            }

            /* FINE SERVIZIO1 ================================================ */
            /* --------------------------------------------------------------- */
            /* SERVIZIO2 ===================================================== */

            else if (servizio.equals("2")){
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome modello:");
                modello = stdIn.readLine();
                outSock.writeUTF(modello);
                
                /* RICEVI UNA DIRECTORY ================================== SNIPPET */
                // Variabili necessarie (da spostare --------------------------------
                byte[] buffer = null;
                int bytes_count = 0;
                int read_bytes = 0;
                int bytes_left = 0;
                DataOutputStream dest_stream = null;
                int dir_status = -1;

                String file_name = null;
                long num_bytes;
                File file = null;
                FileOutputStream outfile = null;

                dir_status = inSock.readInt();
                buffer = new byte[DIM_BUFF];

                if ( dir_status < 0) {
                    System.out.println("Directory richiesta non esistente lato servitore. Stato: " +  dir_status);

                } else{
                    System.out.println("Directory richiesta esistente lato servitore. Stato: " +  dir_status);

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
            
            /* FINE SERVIZIO2 ================================================ */
                
            else {
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1= SERVIZIO1, 2= SERVIZIO2");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
