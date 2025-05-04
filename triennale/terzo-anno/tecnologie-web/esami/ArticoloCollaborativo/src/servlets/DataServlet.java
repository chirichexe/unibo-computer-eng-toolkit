package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.ArticoliManager;
import beans.Articolo;
import beans.Utente;

import java.io.IOException;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i gruppi (ottenuto da ServletContext)
    private ArticoliManager articoliManager;

    @Override
    public void init() throws ServletException {
        super.init();
        articoliManager = (ArticoliManager) getServletContext().getAttribute("articoliManager");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	 Articolo myArticolo = (Articolo) request.getSession().getAttribute("articolo");
    	
    	if (request.getParameter("text") != null) {
    		String newText = request.getParameter("text");
    		System.out.println("Richiede invio: " + newText);
    		myArticolo.setContenuto(newText);
    		
    		
    	} else if (request.getParameter("flag") != null) {
    		Boolean flag = Boolean.parseBoolean(request.getParameter("flag"));
    		if (flag) {
    			response.getWriter().println(articoliManager.richiediModifica(myArticolo.getNome()));
    		} else {
    			articoliManager.rilasciaRichiestaModifica(myArticolo.getNome());
    		}
    	}
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Recupera il nuovo testo dall'input dell'utente
        String articolo = request.getParameter("articolo").replace("%", "");
        
        if (articolo == null || articolo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }

        // Richiede di aggiungere un articolo 
        articoliManager.addArticolo(articolo, request.getSession());

        // Conferma l'aggiunta
        request.getSession().setAttribute("articolo", articoliManager.getArticoloByName(articolo).get());

        response.sendRedirect("articolo.jsp");
    }
}
