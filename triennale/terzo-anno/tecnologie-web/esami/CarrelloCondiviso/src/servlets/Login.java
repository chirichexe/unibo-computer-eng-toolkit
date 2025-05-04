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

import java.io.IOException;
import java.util.HashMap;
import java.util.Map.Entry;
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
    		// 1) Salva l'utente nella sessione
    		// le recupero da frontend con -- String username = (String) session.getAttribute("username");
    		
    		HttpSession session = request.getSession();
    		session.setAttribute("user", utente.get());
    		
    		// 2) Salva ne l'utente nel contesto per tenere traccia della sessione
    		ServletContext context = getServletContext();
    		HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
    		activeSessions.put(session, utente);
    		System.out.println("\n* Si è loggato l'utente " + utente.get() + " con sessionId " + session.getId() + "\n");
    		
    		// Stampa l'elenco degli utenti
    		int numSessioniAutenticate = 0;
    		System.out.println("-------- Elenco utenti attivi --------");
    		for (Entry<HttpSession, Optional<Utente>> entrySession : activeSessions.entrySet() ) {
    			if (entrySession.getValue().isEmpty()) {
    				System.out.println("\t" + entrySession.getKey().getId());
    			}
    			else {
    				numSessioniAutenticate++;
    				System.out.println("\t" + entrySession.getKey().getId() + " - " + entrySession.getValue().get().toString());
    			}
    		}
    		System.out.println("--------------------------------------");
    		// Fine elenco utenti
    		
    		// Gruppi
    		Dati.addUserToGroup(utente.get(), numSessioniAutenticate);
    		
    		// 3) Gesisce la redirezione alla pagina specifica per l'utente
    		response.sendRedirect("user.jsp" );
    	}
    	
    }
    
    
}
