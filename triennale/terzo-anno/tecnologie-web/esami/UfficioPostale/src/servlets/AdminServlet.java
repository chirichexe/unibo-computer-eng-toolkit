package servlets;

import java.io.IOException;

import java.util.HashMap;
import java.util.Optional;
import java.util.Map.Entry;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Utente;

public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		ServletContext context = getServletContext();
		HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
		
		String utentiAttivi = "";
		
		// Stampa l'elenco degli utenti
		System.out.println("-------- Elenco utenti attivi --------");
		for (Entry<HttpSession, Optional<Utente>> entrySession : activeSessions.entrySet() ) {
			if (entrySession.getValue().isEmpty()) {
				System.out.println("\t" + entrySession.getKey().getId());
				utentiAttivi += "\t" + entrySession.getKey().getId();
			} else {
				System.out.println("\t" + entrySession.getKey().getId() + " - " + entrySession.getValue().get().toString());
				utentiAttivi += "\t" + entrySession.getKey().getId() + " - " + entrySession.getValue().get().toString();
			}
		}
		System.out.println("--------------------------------------");
		// Fine elenco utenti
		
		// Stampa l'elenco in uscita
		response.getWriter().print(utentiAttivi);
		   
	}
}
