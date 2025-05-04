package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Bar;
import beans.Utente;

import java.io.IOException;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i gruppi (ottenuto da ServletContext)
    private Bar bar;

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera il nuovo testo dall'input dell'utente
        String nomeDrink = request.getParameter("nomeDrink");
        String idTavolo = (String) request.getSession().getAttribute("idTavolo");
        if (nomeDrink == null || nomeDrink.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }
        
        bar = (Bar) getServletContext().getAttribute("bar");
        if (!bar.addDrinkToTavolo(request.getSession(), nomeDrink, idTavolo)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tavolo non esistente o drink non esistente. Abbiamo solo i gin...");
            return;
        }

        response.setContentType("text/plain");
        response.getWriter().write("Drink aggiunto con successo");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Recupera il nuovo testo dall'input dell'utente
        String numTavolo = request.getParameter("numTavolo");
        if (numTavolo == null || numTavolo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Il testo non può essere vuoto");
            return;
        }
        
        bar = (Bar) getServletContext().getAttribute("bar");
        bar.addUserToTavolo(request.getSession(), numTavolo);
        
        request.getSession().setAttribute("idTavolo", numTavolo);

        // Conferma l'aggiunta
        response.setContentType("text/plain");
        response.getWriter().write("Tavolo aggiunto con successo!");
    }
}
