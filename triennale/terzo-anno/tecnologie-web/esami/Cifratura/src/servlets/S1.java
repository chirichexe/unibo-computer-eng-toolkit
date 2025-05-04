package servlets;

import java.io.BufferedReader;
import java.io.Console;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

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

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	
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
            String [] results = new String[5];
             
            String word = jsonRequest.get("word").getAsString();
            
            Character firstCharacter = 'a';
            for (int i = 0; i < 5; i++) {
            	Map<Character, Character> dictionary = new HashMap<>();
            	for ( int j = 0; j < word.length(); j ++ ) {
            		Character carattereParola = word.charAt(j);
            		Random random = new Random();
            		Character c = 'a';
            		
            		if ( i == 0 ) { // il primo deve essere vocale
            			firstCharacter = carattereParola;
            			do {
            				c = (char)(random.nextInt(26) + 'a');
            			} while ( isVocale(c));
            		} else {
            			do {
            				if ( !carattereParola.equals(firstCharacter) ) 
            					c = (char) (random.nextInt(26) + 'a');
            			} while ( !dictionary.containsValue(c) );
            		}
            		dictionary.put(carattereParola, c);
            	}
            	
            	System.out.println(dictionary.toString());
            	
            	String newWord = word;
            	for (Map.Entry<Character, Character> entry : dictionary.entrySet()) {
            		Character key = entry.getKey();
            		Character val = entry.getValue();
            		newWord = newWord.replace(key, val);
				}
            	
            	results[i] = newWord;
            }
            

            // -------- INVIO RISPOSTA ----------------
            
            Gson gson = new Gson();
            String result = gson.toJson(results, String[].class);

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
    
    public boolean isVocale(char c) {
    	return ( c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' );
    }

}
