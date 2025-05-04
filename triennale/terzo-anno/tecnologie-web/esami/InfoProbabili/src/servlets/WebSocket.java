package servlets;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.StringReader;

import javax.imageio.spi.RegisterableService;
import javax.websocket.*;
import javax.websocket.server.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.*;

@ServerEndpoint("/actions")
public class WebSocket {
	// Oggetti dichiarati "statici" se condivisi e dichiarati solo una volta
    private static List<Session> sessions = Collections.synchronizedList(new ArrayList<Session>());
    public static List<String> messages = Collections.synchronizedList(new ArrayList<String>());
    private static final Random random = new Random();
    
    // Variabili specifiche dichiarate

    @OnOpen
    public void open(Session session) {
        sessions.add(session);
        System.out.println("Nuova connessione WebSocket: " + session.getId());
    }

    @OnClose
    public void close(Session session) {
        sessions.remove(session);
        System.out.println("Connessione WebSocket chiusa: " + session.getId());
    }

    @OnError
    public void onError(Throwable error) {
        error.printStackTrace();
    }

    @OnMessage
    public void handleMessage(String message, Session session) throws IOException {
    	
    	JsonObject jsonObject = JsonParser.parseString(message).getAsJsonObject();
        String type = jsonObject.get("type").getAsString();
        System.out.println("Arrivato il messaggio " + type);

        if ("message".equals(type)) {
            
        	// prendo il messaggio e lo aggiungo all'elenco
        	String data = jsonObject.get("data").getAsString();
        	messages.add(data);
        	
        	// costrusico la risposta
        	JsonObject response = new JsonObject();
        	response.addProperty("type", "message");
        	response.addProperty("data", "Messaggio inviato da " + session.getId() + ": " + data + "\n");
        	percentBroadcast(response.toString());
        	
        } else if ("push".equals(type)) {
        	System.out.println("Un admin ha fatto la push dei messaggi...");
        	JsonObject response = new JsonObject();
        	response.addProperty("type", "push");
        	response.addProperty("messages", messages.toString());
        	broadcast(response.toString());
        }
    }
    
    // Metodo per inviare messaggi all'N% casuake dei client connessi
    public static void percentBroadcast(String message) {
        synchronized (sessions) {
        	// prendo solo il 10%
        	
        	int numSessioniDaPrendere = Math.round(sessions.size() / 10);
        	System.out.println("Lo mando solo a " + numSessioniDaPrendere + " sessioni...");
        	
        	for (int i = 0; i < sessions.size(); i++) {
        		boolean pick = random.nextBoolean();
        		if (pick && numSessioniDaPrendere > 0 ) {
        			numSessioniDaPrendere--;
            		Session session = sessions.get(i);
                    if (session.isOpen()) {
                        try {
                        	session.getBasicRemote().sendText(message);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }        			
        		}
        	}
        }
    }
    

    // Metodo per inviare messaggi a tutti i client connessi
    public static void broadcast(String message) {
        synchronized (sessions) {
            for (Session session : sessions) {
                if (session.isOpen()) {
                    try {
                        session.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}