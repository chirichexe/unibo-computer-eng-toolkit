package servlets;

import java.io.IOException;
import java.io.StringReader;
import java.time.LocalTime;

import javax.websocket.*;
import javax.websocket.server.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.Chat;

import java.util.*;

@ServerEndpoint("/actions")
public class WebSocket {
	// Oggetti dichiarati "statici" se condivisi e dichiarati solo una volta
    private static Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static Chat chat = new Chat();
    
    // Variabili specifiche dichiarate

    @OnOpen
    public void open(Session session) {
        sessions.add(session);
        System.out.println("Nuova connessione WebSocket: " + session.getId());
        try {
        	
        	JsonObject chatObject = new JsonObject();
        	chatObject.addProperty("type", "load");
        	chatObject.addProperty("chat", chat.toString());
        	
			session.getBasicRemote().sendText(chatObject.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
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
        String mex = jsonObject.get("message").getAsString();
        String formattedMessage = session.getId() + " alle " + LocalTime.now().toString() + ": " + mex;

        if ("message".equals(type)) {
        	if ( chat.inviaMessaggio(mex, session) ) {
        		JsonObject broadbastObject = new JsonObject();
        		broadbastObject.addProperty("type", "receivedMessage");
        		broadbastObject.addProperty("message", formattedMessage);
        		broadcast(broadbastObject.toString());
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