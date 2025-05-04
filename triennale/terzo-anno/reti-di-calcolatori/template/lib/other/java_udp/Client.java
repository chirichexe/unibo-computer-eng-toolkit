import java.io.*;
import java.net.*;

public class Client {
    public static void main(String[] args) {
        /* Controllo argomenti */
        if (args.length != 2) {
            System.out.println("Usage: java Client <host> <port>");
            System.exit(1);
        }

        String host = args[0];
        int port = Integer.parseInt(args[1]);
        if (port <= 1024 || port > 65535) {
            System.out.println("Porta non valida");
            System.exit(2);
        }

        /* Creazione socket */
        DatagramSocket socket = null;
        DatagramPacket packet = null;
        byte[] buf = new byte[256];

        try {
            socket = new DatagramSocket();
            InetAddress address = InetAddress.getByName(host);

            /* Invio messaggio */
            System.out.println("Inserisci il messaggio da inviare (EOF per terminare):");
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            String message;

            while ((message = reader.readLine()) != null ) {
                try {
                    ByteArrayOutputStream boStream = new ByteArrayOutputStream();
                    DataOutputStream doStream = new DataOutputStream(boStream);
                    doStream.writeUTF(message);
                    buf = boStream.toByteArray();
                    packet = new DatagramPacket(buf, buf.length, address, port);
                    socket.send(packet);
                    System.out.println("Messaggio inviato: " + message);
                } catch (IOException e) {
                    System.err.println("Problemi nell'invio del messaggio: " + e.getMessage());
                    e.printStackTrace();
                }

                /* Ricezione risposta */
                try {
                    packet = new DatagramPacket(new byte[256], 256);
                    socket.receive(packet);
                    ByteArrayInputStream biStream = new ByteArrayInputStream(packet.getData(), 0, packet.getLength());
                    DataInputStream diStream = new DataInputStream(biStream);
                    String response = diStream.readUTF();
                    System.out.println("Risposta ricevuta: " + response);
                } catch (IOException e) {
                    System.err.println("Problemi nella ricezione della risposta: " + e.getMessage());
                    e.printStackTrace();
                }

                System.out.println("Inserisci un altro messaggio (EOF per terminare):");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (socket != null && !socket.isClosed()) {
                socket.close();
            }
        }
    }
}
