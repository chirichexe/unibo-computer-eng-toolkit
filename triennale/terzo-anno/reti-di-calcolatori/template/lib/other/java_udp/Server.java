import java.io.*;
import java.net.*;

public class Server {
    public static void main(String[] args){
        /* Controllo argomenti */
        if ( args.length != 1) {
            System.out.println("Usage: java host port"); 
            System.exit(1);
        }
    
        int port = Integer.parseInt(args[0]);
        if (port <= 1024 || port > 65535) {
            System.out.println("Porta non valida");
            System.exit(2);
        }
    
        /* Creazione socket */
        DatagramSocket socket = null;
        DatagramPacket packet = null;
        byte[] buf = new byte[256];
    
        try {
            socket = new DatagramSocket(port);
            packet = new DatagramPacket(buf, buf.length);
            System.out.println("Server avviato con socket port: " + socket.getLocalPort()); 
        } catch (SocketException e) {
            System.out.println("Problemi nella creazione della socket: ");
            e.printStackTrace();
            System.exit(1);
        }
    
        /* Ricezione messaggi */
        try{
            // input
            String message;
            ByteArrayInputStream biStream;
            DataInputStream diStream;
            // output
            String risposta = "ricevuto";
            ByteArrayOutputStream boStream;
            DataOutputStream doStream;
            byte[] data = null;
    
            while ( true ){
    
                // Ricezione del datagramma
                try {
                    packet.setData(buf);
                    socket.receive(packet);
                } catch (IOException e) {
                    System.err.println("Problemi nella ricezione del datagramma: "+ e.getMessage());
                    e.printStackTrace();
                    continue;
                    // ciclo ricomincia
                }
    
                // Alloco la stringa del messaggio
                try {
                    biStream = new ByteArrayInputStream(packet.getData(), 0, packet.getLength());
                    diStream = new DataInputStream(biStream);
                    message = diStream.readUTF();
                    System.out.println("Messaggio inviato: " + message);
                } catch (Exception e) {
                    System.err.println("Problemi nella lettura della richiesta: ");
                    e.printStackTrace();
                    continue;
                    // ciclo ricomincia
                }
                
                // Invio della risposta
                try {
                    boStream = new ByteArrayOutputStream();
                    doStream = new DataOutputStream(boStream);
                    doStream.writeUTF(risposta);
                    data = boStream.toByteArray();
                    packet.setData(data, 0, data.length);
                    socket.send(packet);
                } catch (IOException e) {
                    System.err.println("Problemi nell'invio della risposta: "+ e.getMessage());
                    e.printStackTrace();
                    continue;
                    // ciclo ricomincia
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    
        // Chiusura socket
        socket.close();
    
    }

}
