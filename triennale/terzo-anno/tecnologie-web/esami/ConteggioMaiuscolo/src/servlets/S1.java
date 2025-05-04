package servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.UserDataHandler;

import beans.RequestManager;
import beans.Utente;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        RequestManager manager = (RequestManager) getServletContext().getAttribute("requestManager");
        
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }

        // Recupera il nuovo testo dall'input dell'utente
        String target = request.getParameter("target");
        String nomeFile = request.getParameter("nomeFile").replace("%","");
        if (target == null || target.isEmpty() || nomeFile == null || nomeFile.isEmpty() ) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }
        
        // Controllo caratteri alfabetici
        boolean targetIsAlfabetico = true;
        boolean nomeFileIsAlfabetico = true;
        
        for (int i = 0 ; i < target.length(); i++ ) {
        	if ( Character.isDigit(target.charAt(i))){
        		targetIsAlfabetico = false;
        		break;
        	}
        }
        
        for (int i = 0 ; i < nomeFile.length(); i++ ) {
        	if ( Character.isDigit(nomeFile.charAt(i))){
        		nomeFileIsAlfabetico = false;
        		break;
        	}
        }
        
        
        if ( !targetIsAlfabetico || !nomeFileIsAlfabetico ) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo deve avere solo caratteri alfabetici");
            return;
        }
        
        System.out.println("Ottenuti: " + target + " - " + nomeFile);
        System.out.println( System.getProperty("user.dir"));
        
        // Lettura file di testo presente server-side
        StringBuilder testo = new StringBuilder();

        // Legge tutte le righe del file
        try (BufferedReader reader = new BufferedReader(new FileReader(nomeFile))) {
            String linea;
            while ((linea = reader.readLine()) != null) {
            	testo.append(linea);
            }
        }
        
        
        // Metto tutte le righe in touppercase e lo mando alla jsp, prima memorizzando linformazione
        String testoMaiuscolo = testo.toString().toUpperCase();
        request.setAttribute("processedText", testoMaiuscolo);
        
        if (utente.isAdmin()) {
        	manager.aggiungiRichiestaAdmin();
        } else {
        	manager.aggiungiRichiestaUser();
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("J2.jsp");
        dispatcher.forward(request, response);
    }
}
