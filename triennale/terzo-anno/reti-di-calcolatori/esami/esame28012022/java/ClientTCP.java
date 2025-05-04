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
        String parola = null;
        String dirName = null;
        int risultato;
        byte[] buffer = new byte[DIM_BUFF];
        int cont = 0;
        int read_bytes = 0;
        DataOutputStream dest_stream = null;
        
        int soglia = -1;
        String nomeFileRicevuto;
        long numeroByte;
        File fileRicevuto;
        FileOutputStream outfileRicevuto;
        
        /* Servizi fino ad EOF --------------------------------------------------- */
        System.out.println("Inserisci il servizio: 1= ELIMINA OCC. PAROLA, 2= RICEVI FILE SOPRA SOGLIA");
        while ((servizio = stdIn.readLine()) != null) {
            
            /* ELIMINA OCC. PAROLA ===================================================== */
            
            if (servizio.equals("1")) {
                outSock.writeUTF(servizio);
                
                System.out.println("Inserisci nome file:");
                dirName = stdIn.readLine();
                outSock.writeUTF(dirName);
                
                System.out.println("Inserisci nome parola:");
                parola = stdIn.readLine();
                outSock.writeUTF(parola);

                risultato = inSock.readInt();
                System.out.println("Risultato ottenuto:" + risultato); 
            }

            /* FINE ELIMINA OCC. PAROLA ================================================ */
            /* --------------------------------------------------------------- */
            /* RICEVI FILE SOPRA SOGLIA ===================================================== */

            else if (servizio.equals("2")){
                outSock.writeUTF(servizio);
                System.out.println("Inserisci nome directory:");
                dirName = stdIn.readLine();

                System.out.println("Inserisci soglia:");
                try {
                    soglia = Integer.parseInt(stdIn.readLine());
                } catch (NumberFormatException nbe){
                    System.out.println("Numero non intero");
                    continue;
                }
                
                outSock.writeUTF(dirName);
                outSock.writeInt(soglia);

                /* RICEVI UNA DIRECTORY ================================== SNIPPET */

                /* Logica di business -------------------------------------------- */
                if (inSock.readUTF().equals("a")) {
                    System.out.println("Directory richiesta non esistente lato servitore");
                } else{
                    
                    while (!(nomeFileRicevuto = inSock.readUTF()).equals("FINE")) { // protocollo

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
                            outfileRicevuto.close();

                        }
                        outfileRicevuto.close();
                    }
                }

                /* FINE RICEVI UNA DIRECTORY ============================== SNIPPET */

            }
            
            /* FINE RICEVI FILE SOPRA SOGLIA ================================================ */
                
            else {
                System.err.println("Servizio sconosciuto");
            }

            System.out.println("Inserisci il servizio: 1= ELIMINA OCC. PAROLA, 2= RICEVI FILE SOPRA SOGLIA");
        }

        System.out.println("client: termino...");
		socket.close();
    }
}
