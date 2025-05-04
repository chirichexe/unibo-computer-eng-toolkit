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
        
        /* Controllo argomenti --------------------------------------------------- */
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
        String inputId, newId;
        int risultato;
        
        /* Servizi fino ad EOF --------------------------------------------------- */
        System.out.println("Inserisci il servizio: 1= SERVIZIO1, 2= SCARICA FOTO");
        while ((servizio = stdIn.readLine()) != null) {
            
            /* SERVIZIO1 ===================================================== */
            
            if (servizio.equals("1")) {
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome id:");
                inputId = stdIn.readLine();
                outSock.writeUTF(inputId);
                
                System.out.println("Inserisci nuovo id:");
                newId = stdIn.readLine();
                outSock.writeUTF(newId);

                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato); 
            }

            /* FINE SERVIZIO1 ================================================ */
            /* --------------------------------------------------------------- */
            /* SCARICA FOTO ===================================================== */

            else if (servizio.equals("2")){
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome directory:");
                inputId = stdIn.readLine();
                outSock.writeUTF(inputId);
                
                /* RICEVI UNA DIRECTORY ================================== SNIPPET */
                // Variabili necessarie (da spostare --------------------------------
                byte[] buffer = new byte[DIM_BUFF];
                int cont = 0;
                int read_bytes = 0;
                DataOutputStream dest_stream = null;
                
                String nomeFileRicevuto;
                long numeroByte;
                File fileRicevuto;
                FileOutputStream outfileRicevuto;

                if (inSock.readUTF().equals("a")) {
                    System.out.println("Directory richiesta non esistente lato servitore");
                } else{
                    
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
                            System.exit(1);
                        }
                        outfileRicevuto.close();
                    }
                }

                /* FINE RICEVI UNA DIRECTORY ============================== SNIPPET */

            }
            
            /* FINE SCARICA FOTO ================================================ */
                
            else {
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1= SERVIZIO1, 2= SCARICA FOTO");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
