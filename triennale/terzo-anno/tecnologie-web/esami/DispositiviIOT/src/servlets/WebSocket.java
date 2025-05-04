package servlets;

import java.io.IOException;
import java.io.StringReader;
import java.io.ObjectOutputStream.PutField;

import javax.websocket.*;
import javax.websocket.server.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.*;

@ServerEndpoint("/actions")
public class WebSocket {
	// Oggetti dichiarati "statici" se condivisi e dichiarati solo una volta
    public static Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static List<Float> medieMisurazioni = Collections.synchronizedList(new ArrayList<>());
    private static float mediaMisurazioniTotali = 0.0f;
    private static boolean isMonitoringActive = false;
    
    // Variabili specifiche dichiarate

    @OnOpen
    public void open(Session session) {
        sessions.add(session);
        
        if ( !isMonitoringActive )
        	System.out.println("Inizio a monitorare...");
        	startMonitoring();
        
        System.out.println("Nuovo dispositivo collegato: " + session.getId());
    }

    @OnClose
    public void close(Session session) {
        sessions.remove(session);
        System.out.println("Dispositivo disattivato: " + session.getId());
    }

    @OnError
    public void onError(Throwable error) {
        error.printStackTrace();
    }

    @OnMessage
    public void handleMessage(String message, Session session) throws IOException {
    	
    	JsonObject jsonObject = JsonParser.parseString(message).getAsJsonObject();
        String type = jsonObject.get("type").getAsString();
        System.out.println("Arrivato il messaggio " + message);

        if ("misuration".equals(type)) {
            System.out.println( session.getId() + " ha inviato la sua misurazione");
            medieMisurazioni.add(jsonObject.get("media").getAsFloat());
            
        } else if ("disattiva".equals(type)) {
        	String id = jsonObject.get("id").getAsString();
        	if (session.getId().equals(id)){
        		System.out.println("Non puoi disattivare te stesso...");
        	} else {
            	System.out.println( "Un admin ha dichiarato di disattivare " + id  );
            	for (Session s : sessions) {
    				if (s.getId().equals(id)) {
    					System.out.println("Trovato, comunico...");
    					s.getBasicRemote().sendText("Un admin ti ha disattivato, a presto.");
    					s.close();
    					sessions.remove(s);
    				}
    			}
        	}

        }
    }
    
    public static void startMonitoring() {
        new Timer().scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
            	
            	float sommaMedie = 0.0f;
            	for (Float media : medieMisurazioni) {
					sommaMedie += media;
				}
            	
            	if (medieMisurazioni.size() != 0) {
            		mediaMisurazioniTotali = sommaMedie / medieMisurazioni.size();
            		broadcast( "La media di tutti gli: " + sessions.size() + " dispositivi connessi è stata: " + mediaMisurazioniTotali);
            	}
            }
        }, 0, 10_000);
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