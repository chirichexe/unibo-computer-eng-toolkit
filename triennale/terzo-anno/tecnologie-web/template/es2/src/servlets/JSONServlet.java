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

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class JSONServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	// Not implemented...
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
            JsonObject jsonRequest = JsonParser.parseString(jsonText).getAsJsonObject();
            
            // -------- ESTRAZIONE E CONVERSIONE DATI ------------
            
            Gson gson = new Gson();
            
            int requestId = jsonRequest.get("requestId").getAsInt();
            JsonArray matrix1Json = jsonRequest.get("matrix1Part").getAsJsonArray();
            JsonArray matrix2Json = jsonRequest.get("matrix2Part").getAsJsonArray();
            
            int[][] matrix1 = gson.fromJson(matrix1Json, int[][].class);
            int[][] matrix2 = gson.fromJson(matrix2Json, int[][].class);
            int[][] result = new int[matrix1.length][matrix2.length];
            
            // -------------- LOGICA DI BUSINESS -----------------
            
            for (int i = 0; i < matrix1.length; i++) {
				for (int j = 0; j < matrix2.length; j++) {
					result[i][j] = matrix1[i][j] - matrix2[i][j];	
				}
			}
            
            /*
            // Incrementa il numero di richieste completate per la sessione corrente
            // Il sessionListener memorizza la mappa
            
            ServletContext context = getServletContext();
    		HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
            HttpSession actualSession = request.getSession();
            
            if (requestId == 2) {
	            Integer actualValue = activeSessions.get(actualSession) + 1;
	    		activeSessions.put( actualSession, actualValue);
    		}
    		*/
            
            // -------- CREO LA RISPOSTA -------------
            
            String resultString = gson.toJson(result, int[][].class);

            // -------- INVIO RISPOSTA ----------------
            
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
            
            PrintWriter out = response.getWriter();
            out.print(resultString);
            out.flush();
        } catch (Exception e) {
            // Gestione errori
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
            
            JsonObject error = new JsonObject();
            error.addProperty("error", e.getMessage());
            
            PrintWriter out = response.getWriter();
            out.print(error);
            out.flush();
        }
    }
}
