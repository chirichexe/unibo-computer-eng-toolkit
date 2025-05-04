package servlets;

import java.io.BufferedReader;
import java.io.Console;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import javax.naming.directory.NoSuchAttributeException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class S2 extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            
            String word = jsonRequest.get("word").getAsString();
            char [] lettere = word.toCharArray();
            List<Character> lettereList = new ArrayList<>();
            JsonArray anagrammiResult = new JsonArray();
            
            for (char c : lettere) {
				lettereList.add(c);
			}
            
            for (int i = 0; i < 10; i++) {
            	
                boolean statoApplicazione = (boolean) request.getSession().getAttribute("trovata");
                
                if ( !statoApplicazione ) {
                	
                	do {
                		Collections.shuffle(lettereList);
                	} while ( !isVocale(lettereList.get(0)) );
                	
                	StringBuilder anagramma = new StringBuilder();
                	for (int j = 0; j < lettereList.size(); j++) {
                		anagramma.append(lettereList.get(j));
                	}
                	anagrammiResult.add(anagramma.toString());
                } else {
                	response.getWriter().println("Risposta bloccata");
                	return;
                }
            	
			}

            // -------- INVIO RISPOSTA ----------------
            
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
            PrintWriter out = response.getWriter();
            out.print(anagrammiResult);
            out.flush();
        } catch (Exception e) {
            // Gestione errori
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("Errore nellinvio: " + e.getMessage());
            out.flush();
        }
    }
    
    private boolean isVocale(Character c) {
    	return (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' );
    }

}
