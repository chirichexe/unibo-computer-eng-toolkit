package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Dati;

public class S2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String newText = request.getParameter("text");
		
		
		 // Imposta il tipo di contenuto come XML o JSON
		response.setCharacterEncoding("UTF-8");
		
        
        // Scrive la risposta in XML
        /*
        response.setContentType("application/xml");
        response.getWriter().write(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
            "<response>" +
            "<text>" + escapeXml(newText) + "</text>" +
            "</response>"
        );*/
        
        // Scrive la risposta in JSON
		
		response.setContentType("application/json");
        response.getWriter().write(
            "{ \"text\": \"" + escapeJson(newText) + "\" }"
        );
        
        
	}
	
    private String escapeXml(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&apos;");
    }
    
    // Funzione per eseguire l'escape dei caratteri speciali in JSON
    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\"", "\\\"")
                   .replace("\\", "\\\\");
    }
}
