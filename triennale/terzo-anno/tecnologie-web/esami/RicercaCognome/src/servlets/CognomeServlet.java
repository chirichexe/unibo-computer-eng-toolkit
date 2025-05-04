package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class CognomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();
    	
		ServletContext context = getServletContext();
		HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
		
		// Stampa l'elenco delle richieste attive
		out.println("--- Elenco richieste attive ---");
		for (java.util.Map.Entry<HttpSession, Integer> entrySession : activeSessions.entrySet() ) {
			out.println("\t" + entrySession.getKey().getId() +"-> Richieste completate: " + entrySession.getValue());
		}
		out.println("----------------------------");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	
    	String cognomeDaCercare = "Di Modica";
        
    	try {
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
            JsonArray jsonRequest = JsonParser.parseString(jsonText).getAsJsonArray();
            
            
            // -------- ESTRAZIONE E CONVERSIONE DATI ------------
            
            int numVolteCognome = 0; // intero per la somma finale
            
        	JsonArray persone = jsonRequest.getAsJsonArray();
        	for (JsonElement persona : persone) {
				JsonObject object = persona.getAsJsonObject();
				
				String cognome = object.get("cognome").toString().replace("\"", "");
				if (cognome.equals(cognomeDaCercare)) {
					numVolteCognome++;
				}
        	}

            // -------- INVIO RISPOSTA ----------------
            
            ServletContext context = getServletContext();
    		HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
            HttpSession actualSession = request.getSession();
            Integer actualValue = activeSessions.get(actualSession) + 1;
    		activeSessions.put( actualSession, actualValue);

            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(numVolteCognome);
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
