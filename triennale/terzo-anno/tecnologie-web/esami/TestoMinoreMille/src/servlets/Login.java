package servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Dati;
import classes.Utente;
import beans.RequestsManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Optional;

public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Classe dati
    private Dati dati;
    
    // Altre strutture dati da gestire al login 
    // private GroupsManager groupsManager;

    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        dati = (Dati) getServletContext().getAttribute("dati");
        
        // Per sicurezza, controllo se la classe dati non è null, 
        // anche se l'hogià istanziata tramite jsp come bean con 
        // scope di application
        
        if (dati == null) {
        	System.out.println("Dati era null, lo creo");
        	dati = new Dati();
        	getServletContext().setAttribute("dati", dati);
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
        	// Memorizzo l'utente nella sessione corrente
            HttpSession session = request.getSession();
            session.setAttribute("user", utente.get());
            
            // Azioni ulteriori al login

            // ----- MEMORIZZA UTENTE NELLA SESSIONE ATTIVA ----
            /*
            ServletContext context = getServletContext();
            HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = new HashMap<>();
                context.setAttribute("activeSessions", activeSessions);
            }
            activeSessions.put(session, utente);
            */

            // ----- AGGIUNGI L'UTENTE AL GRUPPO ----
            /*
            groupsManager = (GroupsManager) getServletContext().getAttribute("grouspManager");
        	groupsManager.addUser(utente.get());
            System.out.println(groupsManager.getGroupsStatus());
            */

            // Redirezione alla specifica pagina utente
            response.sendRedirect(utente.get().isAdmin() ? "admin.jsp" : "user.jsp");
        }
    }
}
