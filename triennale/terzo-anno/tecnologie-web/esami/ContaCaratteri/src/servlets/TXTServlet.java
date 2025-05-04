package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
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

public class TXTServlet extends HttpServlet {
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
            
            int requestId = jsonRequest.get("requestId").getAsInt();
            
            String part1 = jsonRequest.get("file1part").getAsString();
            String part2 = jsonRequest.get("file2part").getAsString();
            
            // variabili inizializzate
            int maiuscole1 = 0;
            int minuscole1 = 0;
            int maiuscole2 = 0;
            int minuscole2 = 0;
            
            System.out.println("Analizzo il file 1...");
            for (int i = 0; i < part1.length(); i++) {
				if ( Character.isLowerCase(part1.charAt(i))) {
					minuscole1++;
				} else {
					maiuscole1++;
				}
			}

            System.out.println("Analizzo il file 2...");
            for (int i = 0; i < part2.length(); i++) {
				if ( Character.isLowerCase(part2.charAt(i))) {
					minuscole2++;
				} else {
					maiuscole2++;
				}
			}
            
            JsonObject result = new JsonObject();
            result.addProperty("maiuscole1", maiuscole1 );
            result.addProperty("maiuscole2", maiuscole2 );
            result.addProperty("minuscole1", minuscole1 );
            result.addProperty("minuscole2", minuscole2 );
            
            System.out.println("Risposta cosstruita: " + result.toString());

            // -------- MEMORIZZO DATO NELLA SESSIONE ----------------
            
            ServletContext context = getServletContext();
    		HashMap<HttpSession, List<Integer>> activeSessions = (HashMap<HttpSession, List<Integer>>) context.getAttribute("activeSessions");
            HttpSession actualSession = request.getSession();
            
            //System.out.println(actualSession.get));
            
            //1. num. caratteri totali, 2. num caratteri maiuscoli, 2. num caratteri minuscoli
            List<Integer> precedentList = activeSessions.get(actualSession);
            List<Integer> newList = new ArrayList<>();
            
            newList.add(precedentList.get(0) + (maiuscole1 + maiuscole2 + minuscole1 + minuscole2) );
            newList.add(precedentList.get(1) + (minuscole1 + minuscole2) );
            newList.add(precedentList.get(2) + (maiuscole1 + maiuscole2 ) );
            
            activeSessions.put(actualSession, newList );
    		
            // -------- INVIO RISPOSTA ----------------
            
            System.out.println("Invio la risposta: " + result.toString());
            
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
