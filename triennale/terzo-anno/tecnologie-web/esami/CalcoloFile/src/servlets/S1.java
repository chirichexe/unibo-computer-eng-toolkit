package servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.FilesManager;
import beans.Utente;

import java.io.BufferedReader;
import java.io.IOException;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i file (ottenuto da ServletContext)
    private static final int MAX_REQUEST = 100;
    private FilesManager filesManager;

    @Override
    public void init() throws ServletException {
        super.init();
        filesManager = (FilesManager) getServletContext().getAttribute("filesManager");
        if (filesManager == null) {
            filesManager = new FilesManager();
            getServletContext().setAttribute("filesManager", filesManager);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }

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
        
        String fileName = jsonRequest.get("fileName").getAsString();
        String responseString = "";
        
        if (utente.getRequests() < MAX_REQUEST) {
        	//if (filesManager.getFileByName())
        	utente.addRequest();
            request.setAttribute("fileName", fileName);
            
            System.out.println("Redireziono alla servlet J1...");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("J1.jsp");
            dispatcher.forward(request, response);
        } else {
        	responseString = "Hai raggiunto il limite di richieste: " + MAX_REQUEST;
        }

        // Conferma l'aggiunta
        response.setContentType("text/plain");
        response.getWriter().write(responseString);
    }
}
