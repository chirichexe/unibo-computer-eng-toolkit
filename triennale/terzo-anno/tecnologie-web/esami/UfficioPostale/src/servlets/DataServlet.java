package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.UfficioManager;
import beans.Utente;

import java.io.IOException;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i gruppi (ottenuto da ServletContext)
    private UfficioManager ufficioManager;

    @Override
    public void init() throws ServletException {
        super.init();
        ufficioManager = (UfficioManager) getServletContext().getAttribute("ufficioManager");
        if (ufficioManager == null) {
            ufficioManager = new UfficioManager();
            getServletContext().setAttribute("ufficioManager", ufficioManager);
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
        

        // Recupera il nuovo testo dall'input dell'utente
        String servizio = request.getParameter("servizio");
        if (servizio == null || servizio.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il servizio non può essere vuoto");
            return;
        }
        
        // Ottengo il tempo d'attesa e lo invio
    	int tempoAttesa = ufficioManager.addUser(utente, servizio);
        response.getWriter().write("Servizio richiesto con successo.\nTempo di attesa: " + tempoAttesa  + " minuti");
    }
}
