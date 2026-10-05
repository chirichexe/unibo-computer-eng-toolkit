/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

package servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class S1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    	System.out.println("S1: Sono in esecuzione...");
    		
		// ---- Parametri in ingresso ---- 
		
		String text = request.getParameter("text");
		
		// ---- Esecuzione programma ----- 
		
		int randomCharId = (int) (Math.random() * text.length());
		char toReplace = text.charAt(randomCharId);
		text = text.replace(toReplace, 'a');
		
		// ---- Stampa in uscita --------- 
		request.setAttribute("processedText", text);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("J2.jsp");
		dispatcher.forward(request, response);
    	
    }
}
