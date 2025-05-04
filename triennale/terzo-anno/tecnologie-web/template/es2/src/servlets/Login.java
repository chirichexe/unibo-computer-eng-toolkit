package servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Dati;
import classes.Utente;

import java.io.IOException;
import java.util.Optional;

public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Dati dati;
    
    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        
        dati = (Dati) getServletContext().getAttribute("dati");
        
    }
    
    public void doPost (HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
    	String username = request.getParameter("username");
    	String password = request.getParameter("password");
    	
    	Optional<Utente> utente = dati.getUtente(username, password);
    	
    	if (utente.isEmpty()) {
    		response.sendRedirect("index.jsp?error=invalid+credentials"); // Reindirizza alla pagina di login se non registrato    		
    	} else {
    		// 1) Salva l'utente nella sessione
    		HttpSession session = request.getSession();
    		session.setAttribute("user", utente.get());
    		
    		response.sendRedirect("admin.jsp" );
    	}
    	
    }
    
    
}
