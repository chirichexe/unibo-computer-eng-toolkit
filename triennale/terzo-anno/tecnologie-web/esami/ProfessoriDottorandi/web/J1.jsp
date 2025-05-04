<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="beans.Utente"%>
<%

	// Recupera l'utente dalla sessione
	Utente utente = (Utente) request.getSession().getAttribute("user");
	if (utente == null) {
	    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
	    return;
	}

	// -------- LETTURA DATI ---------------------------
	String data = request.getParameter("jsonData");
	System.out.println("Ricevuto: " + data);
	JsonObject obj = JsonParser.parseString(data).getAsJsonObject();
	
	Random ran = new Random();
	
	for ( int i = 0; i < obj.get("numFiles").getAsInt() ; i++ ){
		String file = obj.get("file" + (i+1)).getAsString();
		int lunghezzaByte = ran.nextInt(0, 20000);
		int numPag = Math.round( lunghezzaByte/100);
		System.out.println("trovato file: " + file + " lungo " + numPag);
		if ( numPag >= 10 ) {
			response.sendRedirect("S1?fileName=" + file + "&fileLength=" + numPag);
		}else {
			response.sendRedirect("S2?fileName=" + file + "&fileLength=" + numPag);
		}
	}

%>
