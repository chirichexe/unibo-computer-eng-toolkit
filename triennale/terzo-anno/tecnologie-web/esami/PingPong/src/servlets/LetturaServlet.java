package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.LocalTime;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.Dati;

public class LetturaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    Dati dati = new Dati();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();
        out.print(dati.leggi());
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	LocalDateTime inizio = LocalDateTime.parse(request.getParameter("inizio"));
    	
    	System.out.println("Avvio la sfida per l'user1 all'orario: " + inizio.toString());
    	dati.iniziaSfida(dati.getUtente("user1", "1").get(), inizio);
    	
    	PrintWriter out = response.getWriter();
        out.println("<a href=\"user.jsp\">Sei prenotato! torna alla home</a>");
        out.flush();
    	
    }
}
