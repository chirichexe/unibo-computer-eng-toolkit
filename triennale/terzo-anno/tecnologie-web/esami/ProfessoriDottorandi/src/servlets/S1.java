package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.GroupsManager;
import beans.Utente;

import java.io.BufferedReader;
import java.io.IOException;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'utente dalla sessione
        Utente utente = (Utente) request.getSession().getAttribute("user");
        if (utente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }

        // -------- LETTURA BUFFER ---------------------------
        String nome = request.getParameter("fileName");
        String lunghezza = request.getParameter("fileLength");
        
        
        
        response.getWriter().println("Il file " + nome + " è lungo " + lunghezza + " pagine. FRONTE" );
    }
}
