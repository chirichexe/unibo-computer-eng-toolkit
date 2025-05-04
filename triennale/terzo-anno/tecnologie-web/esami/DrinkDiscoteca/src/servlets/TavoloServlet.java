package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import beans.Bar;

import java.io.IOException;

public class TavoloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il manager per i gruppi (ottenuto da ServletContext)
    private Bar bar;

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTavolo = (String) request.getSession().getAttribute("idTavolo");
        bar = (Bar) getServletContext().getAttribute("bar");
        float prezzo = bar.getPrezzoTavolo(idTavolo);

        response.getWriter().write("Prezzo per il tavolo: " + prezzo + " euro.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTavolo = (String) request.getSession().getAttribute("idTavolo");
        HttpSession user = request.getSession();
        bar = (Bar) getServletContext().getAttribute("bar");
        float prezzo = bar.getPrezzoTavolo(idTavolo, user);

        response.getWriter().write("Prezzo per il cliente: " + user.getId() + ": " + prezzo + " euro.");
    }
}
