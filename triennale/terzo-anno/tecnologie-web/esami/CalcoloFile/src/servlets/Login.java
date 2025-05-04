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
import beans.FilesManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Optional;

public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Dati dati;
    private FilesManager filesManager;

    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        dati = (Dati) getServletContext().getAttribute("dati");
        filesManager = (FilesManager) getServletContext().getAttribute("filesManager");
        
        if (dati == null) {
        	System.out.println("Dati era null, lo creo");
        	dati = new Dati();
        	getServletContext().setAttribute("dati", dati);
        }
        
        if (filesManager == null) {
        	System.out.println("filesManager era null, lo creo");
            filesManager = new FilesManager();
            getServletContext().setAttribute("filesManager", filesManager);
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

            // Redirezione
            response.sendRedirect(utente.get().isAdmin() ? "admin.jsp" : "user.jsp");
        }
    }
}
