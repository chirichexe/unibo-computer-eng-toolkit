package servlets;

import java.io.BufferedReader;
import java.io.Console;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.time.LocalTime;
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

public class JSONServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();
    	
		ServletContext context = getServletContext();
		List<HttpSession> activeSessions = (List<HttpSession>) context.getAttribute("activeSessions");
		
		// Stampa l'elenco delle richieste attive
		out.println("--- Elenco richieste attive ---");
		for (HttpSession session : activeSessions ) {
			out.println("\t" + session.getId() );
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
            
            
            JsonArray result = new JsonArray();
            JsonArray A = jsonRequest.get("A").getAsJsonArray();
            JsonArray B = jsonRequest.get("B").getAsJsonArray();
            
            System.out.println("Matrice A: " + A.toString());
            System.out.println("Matrice B: " + B.toString());
            
            long start = System.nanoTime();
            
            JsonArray row = new JsonArray();
            for (int i = 0; i < A.size(); i++) {
            	              	
            	int m1 = A.get(i).getAsInt();
            	int m2 = B.get(i).getAsInt();
            	int res = m1 - m2;
            	
            	row.add(res);                
            }
            
            result.add(row);
            long end = System.nanoTime();
            long time = end - start;
            
            System.out.println("Risultato: " + result.toString());
            System.out.println("Tempo: " + time);
            
            JsonObject responseObject = new JsonObject();
            responseObject.add("result", result);
            responseObject.addProperty("time", time);

            // -------- INVIO RISPOSTA ----------------
            
    	
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
            PrintWriter out = response.getWriter();
            out.print(responseObject.toString());
            out.flush();
        } catch (Exception e) {
            // Gestione errori
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("Errore nell'invio: " + e.getMessage());
            out.flush();
        }
    }

}
