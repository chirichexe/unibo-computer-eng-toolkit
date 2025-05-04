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
import beans.ArticoliManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Optional;

public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Dati dati;

    @Override
    public void init(ServletConfig conf) throws ServletException {
        super.init(conf);
        dati = (Dati) getServletContext().getAttribute("dati");
        
        if (dati == null) {
        	System.out.println("Dati era null, lo creo");
        	dati = new Dati();
        	getServletContext().setAttribute("dati", dati);
        }

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Optional<Utente> utente = dati.getUtente(username, password);

        if (utente.isEmpty()) {
            response.sendRedirect("index.jsp?error=invalid+credentials");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("user", utente.get());

            // Redirezione
            response.sendRedirect("admin.jsp");
        }
    }
}
