package servlets;

import java.io.IOException;

import javax.swing.plaf.basic.BasicInternalFrameTitlePane.IconifyAction;
import javax.websocket.*;
import javax.websocket.server.*;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.*;

@ServerEndpoint("/actions")
public class WebSocket {
	// Oggetti dichiarati "statici" se condivisi e dichiarati solo una volta
	// per essere accessibili da ogni "utente" delle websocket con scope
	// di application
	
    private static Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static Set<Session> tavolo = Collections.synchronizedSet(new HashSet<>());
    private static final Random random = new Random();
    
    // Variabili specifiche dichiarate
    private static boolean isTimerStarted = false;
    private static boolean isStarted = false;

    @OnOpen
    public void open(Session session) {
        sessions.add(session);
        System.out.println("Nuova connessione WebSocket: " + session.getId());
        
    	if (sessions.size() == 5) {
    		isStarted = true;
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
        
        System.out.println("Arrivato il messaggio di tipo -" + type + "- dall'utente: " + session.getId());
        
        // Type rappresenta il tipo di azione che è stata richiesta lato client
        // switch tra le varie possibilità
        
        if ("action".equals(type)) {
        	handleFinePartita();
            broadcast( session.getId() + " ha dichiarato di fare Tombola.");
        } else if ("leave".equals(type)) {
            sessions.remove(session);
            broadcast( session.getId() + " ha dichiarato di abbandonare.");
        } else if ("enter".equals(type)) {
        	tavolo.add(session);
        	if ( tavolo.size() == 5) {
        		isStarted = true;
        		System.out.println("Partita iniziata");
        		startPartita();
        	} else {
        		System.out.println("Aspetto altre persone...");
        	}
        	handleEntraUtente(session);
        } else {
        	System.err.println("Azione sconosciuta: " + type);
        }
    }
    
    public static void startPartita() {
        new Timer().scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
            	if ( isStarted ) {
            		int number = random.nextInt(90) + 1;
            		broadcast("New number: " + number);
            	}
            }
        }, 0, 10_000);
    }
    
    public void handleEntraUtente(Session s) {
    	if ( !isStarted ) {
    		tavolo.add(s);
    		new Thread( () -> {
    			try {
					Thread.sleep(20  * 1000);
					if (!isStarted) {
						System.out.println("Non ci sono abbastanza persone. Tavolo chiuso.");
						svuotaTavolo();
						isTimerStarted = false;
					} 
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
    		}).start();; 
    	}
    }
    
    public void handleFinePartita() {
    	svuotaTavolo();
    }
    
    
    private void svuotaTavolo() {
    	System.out.println("Svuoto il tavolo...");
    	tavolo.clear();
    	isStarted = false;
    	
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