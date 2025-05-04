package servlets;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    	System.out.println("S1: Sono in esecuzione...");
    		
		// ---- Parametri in ingresso ---- 
		
		String fileName = request.getParameter("fileName").replace("%", "");
		
		// ---- Esecuzione programma ----- 

        StringBuilder testo = new StringBuilder();
        String processedText = "";

        // Legge tutte le righe del file
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String linea;
            while ((linea = reader.readLine()) != null) {
            	testo.append(linea);
            }
        }

        // Stampa il file maiuscolo
        processedText = testo.toString().toUpperCase();
		
		// ---- Stampa in uscita --------- 
		request.setAttribute("processedText", processedText);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("J2.jsp");
		dispatcher.forward(request, response);
    	
    }
}
