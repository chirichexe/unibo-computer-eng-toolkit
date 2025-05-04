package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.RequestsManager;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    	System.out.println("S1: Sono in esecuzione...");
    	
    	RequestsManager manager = (RequestsManager) getServletContext().getAttribute("requestsManager");
    	
    	if ( manager.getNumRichiesteInCorso() >= 3 ) {
    		System.out.println("Attendo...");
    		RequestDispatcher dispatcher = request.getRequestDispatcher("wait.jsp");
    		dispatcher.forward(request, response);
    		return;
    	}
    	
    	manager.faiRichiesta();
    	
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
		String text = jsonRequest.get("word").getAsString();
		
		// ---- Esecuzione programma ----- 
		
		Random random = new Random();
		int n = random.nextInt( 0,9 );
		System.out.println("Randomizzato: " + n);
		
		char [] caratteri = text.toCharArray();
		
		for (int i = 0; i < text.length() ; i++) {
			if ( isMultiplo(i, n) ) {
				
				caratteri[i] = ' ';
			}
		}
		
		StringBuilder newText = new StringBuilder();
		for (int i = 0; i < caratteri.length; i++) {
			if(caratteri[i] != ' ') 
				newText.append(caratteri[i]);
		}
		
		// ---- Stampa in uscita --------- 
		request.setAttribute("processedText", newText.toString());
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("J2.jsp");
		dispatcher.forward(request, response);
    	
    }
    
    private boolean isMultiplo(int a, int b) {
    	return a % b == 0;
    }
}
