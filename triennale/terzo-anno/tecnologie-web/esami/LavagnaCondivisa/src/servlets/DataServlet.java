package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.GroupsManager;
import beans.Utente;

import java.io.IOException;
import java.util.Optional;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i gruppi (ottenuto da ServletContext)
    private GroupsManager groupsManager;

    @Override
    public void init() throws ServletException {
        super.init();
        groupsManager = (GroupsManager) getServletContext().getAttribute("groupsManager");
        if (groupsManager == null) {
            groupsManager = new GroupsManager();
            getServletContext().setAttribute("groupsManager", groupsManager);
        }
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
        String groupText = groupsManager.getLavagna(utente);
        response.setContentType("text/plain");
        response.getWriter().write(groupText);
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
        String newText = request.getParameter("elemento");
        if (newText == null || newText.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }

        // Aggiunge il testo al gruppo dell'utente
        groupsManager.appendText(utente, newText);
        groupsManager.setIsNotEditing();

        // Conferma l'aggiunta
        response.sendRedirect("user.jsp");
    }
}
