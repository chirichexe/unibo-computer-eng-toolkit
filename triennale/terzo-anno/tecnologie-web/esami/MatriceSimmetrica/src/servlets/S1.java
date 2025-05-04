package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	
    	Map<HttpSession, Boolean> richieste = (HashMap<HttpSession, Boolean>) getServletContext().getAttribute("richieste");
    	
    	if ( richieste == null ) {
    		richieste = new HashMap<>();
    		System.out.println("Richieste mai istanziate, le istanzio...");
    		getServletContext().setAttribute("richieste", richieste);
    	}
    	System.out.println("Nuova richiesta da " + request.getSession().getId());
    	richieste.put(request.getSession(), true);
    		
    	
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
            
            boolean result = true;
            JsonArray matrix = jsonRequest.get("matrixPart").getAsJsonArray();
            
            for (int i = 0; i < matrix.size(); i++) {
            	
                for (int j = 0; j < matrix.get(i).getAsJsonArray().size(); j++) {                	
                	int elij = matrix.get(i).getAsJsonArray().get(j).getAsInt();
                	int elji = matrix.get(j).getAsJsonArray().get(i).getAsInt();
                	if (i < j) {
                		System.out.println("Analizzo elementi " + elij + " - " + elji);
                		
                		if (elij != elji) {
                			result = false;
                			break;
                		}
                	}
                }
            }

            // -------- INVIO RISPOSTA ----------------
            
            System.out.println("Risposta S1 " + result);
            PrintWriter out = response.getWriter();
            response.setCharacterEncoding("UTF-8");
            
            System.out.println("Stato richiesta:" + richieste.get(request.getSession()));
            
            if (!richieste.get(request.getSession())) {
            	System.out.println("Richiesta invalidata...");
            	out.print("-1");
            } else {
            	out.print(result);
            	out.flush();
            }
    	
            
        } catch (Exception e) {
            // Gestione errori
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("Errore nellinvio: " + e.getMessage());
            out.flush();
        }
    }

}
