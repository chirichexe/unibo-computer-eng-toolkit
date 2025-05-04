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

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class JSONServlet extends HttpServlet {
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
            
            // -------- ESTRAZIONE E CONVERSIONE DATI ------------
            
            JsonObject jsonRequest = JsonParser.parseString(jsonText).getAsJsonObject();
            JsonArray matrix = jsonRequest.get("matrixPart").getAsJsonArray();
            
            int max = -1;
            int min = -1;
            int numeriProcessati = 0; 
            
            for (int i = 0; i < matrix.size(); i++) {
            	JsonArray row = matrix.get(i).getAsJsonArray();
            	for (int j = 0; j < row.size(); j++) {
            		
            		int el = row.get(j).getAsInt();
            		
            		max = (max == -1 ? el : Math.max(max, el));
            		min = (min == -1 ? el : Math.min(min, el));
            		
            		numeriProcessati++;
            	}
            }
            
            JsonObject result = new JsonObject();
            result.addProperty("max", max);
            result.addProperty("min", min);
            System.out.println("Calcolato... " + result);

            // -------- INVIO RISPOSTA ----------------
            
            ServletContext context = getServletContext();
    		HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
            HttpSession actualSession = request.getSession();
            
            Integer actualValue = activeSessions.get(actualSession) + numeriProcessati;
    		activeSessions.put( actualSession, actualValue);

    	
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
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
