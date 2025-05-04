package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.security.KeyStore.Entry;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CountDownLatch;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import beans.Dati;
import beans.Giocatore;

public class JSONServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {    
    	String surname = request.getParameter("cognome");
    	Dati dati = (Dati) getServletContext().getAttribute("dati");
    	
    	System.out.println("Ricerco: " + surname);
    	System.out.println(dati.toString());
    	
    	Optional<List<Giocatore>> ottenuto = dati.getGiocatoriByOne(surname);
    	if (ottenuto.isEmpty()) {
    		JsonObject error = new JsonObject();
    		error.addProperty("error", "Non partecipa agli US Open 2022");
    		response.getWriter().print(error.toString());
    		
    	} else {
    		Gson gson = new Gson();
    		String result = gson.toJson(ottenuto.get(), ottenuto.get().getClass() );
    		response.getWriter().print(result);
    	}
    	
    }

}
