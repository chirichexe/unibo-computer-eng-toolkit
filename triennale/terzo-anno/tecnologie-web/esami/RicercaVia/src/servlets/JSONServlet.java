package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import javax.imageio.ImageTranscoder;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.SessionData;

public class JSONServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String SEARCH_STRING = "Via Ugo Bassi";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();
    	
		ServletContext context = getServletContext();
		HashMap<HttpSession, SessionData> activeSessions = (HashMap<HttpSession, SessionData>) context.getAttribute("activeSessions");
		
		// Stampa l'elenco delle richieste attive
		out.println("--- Elenco richieste attive ---");
		for (java.util.Map.Entry<HttpSession, SessionData> entrySession : activeSessions.entrySet() ) {
			out.println("\t" + entrySession.getKey().getId() +" -> " + entrySession.getValue());
		}
		out.println("----------------------------");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {    
    	try {
    		
    		long start = System.currentTimeMillis();
    		
            // -------- LETTURA BUFFER ---------------------------
            StringBuilder jsonBuffer = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuffer.append(line);
                }
            }

            // mostra il JSON ricevuto per debug e lo analizza
            String jsonText = jsonBuffer.toString();
            System.out.println("JSON ricevuto: " + jsonText);
            
            // -------- ESTRAZIONE E CONVERSIONE DATI ------------
            
            JsonObject jsonRequest = JsonParser.parseString(jsonText).getAsJsonObject();
            int requestId = jsonRequest.get("requestId").getAsInt();
            int count = 0;
            
            JsonArray content = jsonRequest.get("contentPart").getAsJsonArray();
            
            for (int i = 0; i < content.size(); i++) {
            	JsonObject elemento = content.get(i).getAsJsonObject();
            	String indirizzo = elemento.get("indirizzo").getAsString();
            	System.out.println("Indirizzo: " + indirizzo);
            	if(indirizzo.equals(SEARCH_STRING)) {
            		count++;
            	}
            }

            // -------- INVIO RISPOSTA ----------------
            
            ServletContext context = getServletContext();
    		HashMap<HttpSession, SessionData> activeSessions = (HashMap<HttpSession, SessionData>) context.getAttribute("activeSessions");
            HttpSession actualSession = request.getSession();
            SessionData sessionData = activeSessions.get(actualSession);
            
            // 1. Memorizzo quelle completate
            if (requestId == 1) {
            	sessionData.addCompletate();
    		}
            // 2. Aggiungo la durata
            long end = System.currentTimeMillis();
            sessionData.addDuration(( end - start ));
            
            Gson gson = new Gson();
            String result = gson.toJson(count);
    	
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(result);
            out.flush();
        } catch (Exception e) {
            // Gestione errori
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("Errore nellinvio: " + e.getMessage());
            out.flush();
        }
    }

}
