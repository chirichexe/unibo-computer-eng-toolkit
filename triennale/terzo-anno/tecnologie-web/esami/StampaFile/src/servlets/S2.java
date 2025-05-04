package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class S2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Integer num = Integer.valueOf(request.getParameter("numPagine"));
		String nomeFile = request.getParameter("nomeFile");
		
		PrintWriter out = response.getWriter();
		out.println("Il file " + nomeFile + " è lungo " + num + " - stampato fronte retro");
		out.println("<a href=\"user.jsp\">torna indietro<a>");
	}
}
