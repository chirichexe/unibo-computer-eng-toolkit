<%@page import="beans.RequestManager"%>
<%@page import="classes.Utente"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" %>

<%
	System.out.println("J2: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
    String processedText = (String) request.getAttribute("processedText");
    String target = request.getParameter("target");

	// ---- Esecuzione programma ----- 
	
    int count = 0;
	if (!target.isEmpty()) {
        int index = processedText.indexOf(target);
        while (index != -1) {
            count++;
            index = processedText.indexOf(target, index + target.length());
        }
    }
	
	JsonObject result = new JsonObject();
	result.addProperty("testoMaiuscolo", processedText );
	result.addProperty("numOccorrenze", count );
	
    Utente user = (Utente) session.getAttribute("user");
    
    if (user.isAdmin() ) {
    	user.addRichiestaAdmin();
    } else {
    	RequestManager richieste = (RequestManager) getServletContext().getAttribute("requestManager");
    	richieste.addRichiesta( request.getSession() );
    }
	
	
    // ---- Stampa in uscita ---------
    
    out.write(result.toString());
    out.flush();
    
%>
