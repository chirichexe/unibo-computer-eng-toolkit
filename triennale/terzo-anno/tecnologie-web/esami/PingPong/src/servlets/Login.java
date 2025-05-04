package servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Dati;
import beans.Utente;

import java.io.IOException;
import java.util.HashMap;
import java.util.Optional;


public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    //istanzio il "database" per gli utenti
    Dati dati = new Dati();

    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        
    }
    
    public void doPost (HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
    	String username = request.getParameter("username");
    	String password = request.getParameter("password");
    	
    	Optional<Utente> utente = dati.getUtente(username, password);
    	
    	if (utente.isEmpty()) {
    		response.sendRedirect("index.jsp?error=invalid+credentials"); // Reindirizza alla pagina di login se non registrato    		
    	} else {
    		// Salva l'utente nella sessione
    		// le recupero da frontend con -- String username = (String) session.getAttribute("username");
    		
    		HttpSession session = request.getSession();
    		session.setAttribute("username", utente.get().getUsername());
    		
    		// Altre specifiche del problema da memorizzare nella "sessione", es:
    		// session.setAttribute("counter", 0);
    		session.setAttribute("isPrenotato", utente.get().isPrenotato());
    		
    		response.sendRedirect("user.jsp" );
    	}
    	
    }
    
    
}
