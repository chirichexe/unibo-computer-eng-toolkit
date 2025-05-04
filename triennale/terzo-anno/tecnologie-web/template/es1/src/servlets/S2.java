package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.gson.JsonObject;


public class S2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		System.out.println("S2: Sono in esecuzione...");
		
		// ---- Parametri in ingresso ----
		
		String processedTextString = (String) request.getAttribute("processedText");
		
		// ---- Esecuzione programma ----- 
		
		int randomCharId = (int) (Math.random() * processedTextString.length());
		char toReplace = processedTextString.charAt(randomCharId);
		processedTextString = processedTextString.replace(toReplace, 'a');
		
		// ---- Stampa in uscita ---- 
		
		JsonObject resultJsonObject = new JsonObject();
		resultJsonObject.addProperty("value", processedTextString);
		
		response.setContentType("application/JSON");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().println(resultJsonObject);
		
	}

}
