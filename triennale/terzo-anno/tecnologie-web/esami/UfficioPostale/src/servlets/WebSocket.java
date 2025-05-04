package servlets;

import java.io.IOException;

import javax.websocket.*;
import javax.websocket.server.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.*;

@ServerEndpoint("/actions")
public class WebSocket {
    private static Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

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
        System.out.println("Messaggio ricevuto: " + message);
        // Risposta opzionale al client
        session.getBasicRemote().sendText("Messaggio ricevuto: " + message);
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
