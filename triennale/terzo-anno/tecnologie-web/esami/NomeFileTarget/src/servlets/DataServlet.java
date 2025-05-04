package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.RequestManager;
import classes.Utente;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Gestore risorse comuni
    //private GroupsManager groupsManager;

    @Override
    public void init() throws ServletException {
        super.init();
        
        // Prendo il gestore delle risorse comuni dal servletContext
        //groupsManager = (GroupsManager) getServletContext().getAttribute("groupsManager");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }

        // Ottiene il testo del gruppo dell'utente
        String responseText = "risposta"; 
        //= groupsManager.getGroupString(utente);
        
        // ---- RISPOSTA ----
        response.setContentType("text/plain");
        
        //response.setContentType("text/html");
        //response.setContentType("application/json");
        //response.setContentType("application/xml");

        response.getWriter().write(responseText);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        
        // CASO 1: RICHIESTA NON JSON
        
        /*
        // Recupera il nuovo testo dall'input dell'utente
        String elemento = request.getParameter("elemento");
        // Controllo integrità dati
        if (elemento == null || elemento.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }

        // Gestione risorsa POST
        //groupsManager.appendText(utente, newText);

		// Invio risposta come "nuova pagina"
        response.setContentType("text/plain");
        
        //response.setContentType("text/html");
        //response.setContentType("application/json");
        //response.setContentType("application/xml");

        response.getWriter().write("Richiesta ricevuta con successo!");
        
        */
        
        // CASO 2: RICHIESTA JSON
        
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
            
            String type = jsonRequest.get("type").getAsString();
            String content = jsonRequest.get("content").getAsString();
            JsonObject result = new JsonObject();
            
            // -------------- LOGICA DI BUSINESS -----------------
            
            if ( "testo".equals(type) ) {
            	
            	 //groupsManager.appendText(utente, content);
            	System.out.println("Inserisco: " + content);
            	result.addProperty("success", "Richiesta avvenuta con successo");
            	
            } else {
            	System.err.println("Tipo richiesta sconosciuta: " + type);
            	result.addProperty("error", "Richiesta sconosciuta");
            }

            // -------- INVIO RISPOSTA ----------------
            
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/JSON");
            PrintWriter out = response.getWriter();
            out.write(result.toString());
            out.flush();
        } catch (Exception e) {
        	
        	JsonObject result = new JsonObject();
        	result.addProperty("error", e.getMessage());
        	
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(result);
            out.flush();
        }
    }
}
