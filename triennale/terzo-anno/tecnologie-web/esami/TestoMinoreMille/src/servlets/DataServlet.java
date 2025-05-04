package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.RequestsManager;
import classes.Utente;

import java.io.IOException;

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

        // Recupera il nuovo testo dall'input dell'utente
        String elemento = request.getParameter("elemento");
        // Controllo integrità dati
        if (elemento == null || elemento.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }

        // Gestione risorsa POST
        //groupsManager.appendText(utente, newText);

        // ---- RISPOSTA ----
        response.setContentType("text/plain");
        
        //response.setContentType("text/html");
        //response.setContentType("application/json");
        //response.setContentType("application/xml");

        response.getWriter().write("Richiesta ricevuta con successo!");
    }
}
