package servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Dati;
import beans.Utente;
import beans.GroupsManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Optional;

public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Dati dati;
    private GroupsManager groupsManager;

    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        dati = (Dati) getServletContext().getAttribute("dati");
        groupsManager = (GroupsManager) getServletContext().getAttribute("groupsManager");
        
        if (dati == null) {
        	System.out.println("Dati era null, lo creo");
        	dati = new Dati();
        	getServletContext().setAttribute("dati", dati);
        }
        
        if (groupsManager == null) {
        	System.out.println("GroupsManager era null, lo creo");
            groupsManager = new GroupsManager();
            getServletContext().setAttribute("groupsManager", groupsManager);
        }

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Optional<Utente> utente = dati.getUtente(username, password);

        if (utente.isEmpty()) {
            response.sendRedirect("index.jsp?error=invalid+credentials");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("user", utente.get());

            // Aggiorna il contesto con la sessione attiva
            ServletContext context = getServletContext();
            HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = new HashMap<>();
                context.setAttribute("activeSessions", activeSessions);
            }
            activeSessions.put(session, utente);

            // Aggiungi l'utente al gruppo
        	groupsManager.addUser(utente.get());
            System.out.println(groupsManager.getGroupsStatus());

            // Redirezione
            response.sendRedirect(utente.get().isAdmin() ? "admin.jsp" : "user.jsp");
        }
    }
}
