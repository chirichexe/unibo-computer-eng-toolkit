package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;
import java.util.Set;
import java.util.Map.Entry;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;

import beans.Carrello;
import beans.Dati;
import beans.Utente;


public class CarrelloServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/*
	// Stampa l'elenco degli utenti
	System.out.println("-------- Elenco utenti attivi --------");
	for (Entry<HttpSession, Optional<Utente>> entrySession : activeSessions.entrySet() ) {
		if (entrySession.getValue().isEmpty())
			System.out.println("\t" + entrySession.getKey().getId());
		else
			System.out.println("\t" + entrySession.getKey().getId() + " - " + entrySession.getValue().get().toString());
	}
	System.out.println("--------------------------------------");
	// Fine elenco utenti
	*/
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		int idCarrello = Integer.parseInt(request.getParameter("idCarrello"));
		
		Carrello carrello = new Carrello();
		
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		String json = "Nessun carrello trovato";  
		
		if (idCarrello == 1) {
			json = gson.toJson(carrello.getCarrello1());
		} else {
			json = gson.toJson(carrello.getCarrello2());			
		}
		
		PrintWriter out = response.getWriter();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");

		out.print(json);
        
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		int quantita = Integer.parseInt(request.getParameter("quantita"));
		String articolo = request.getParameter("articolo");
		String azione = request.getParameter("azione");
		
		
		PrintWriter out = response.getWriter();
		out.flush();
        
	}


}
