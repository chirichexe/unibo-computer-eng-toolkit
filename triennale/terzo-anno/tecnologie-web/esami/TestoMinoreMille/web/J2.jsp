<%@page import="beans.RequestsManager"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" %>

<%
	System.out.println("J2: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
    String processedText = (String) request.getAttribute("processedText");

	// ---- Esecuzione programma ----- 
	int numMaiuscole = 0;
	for ( int i = 0; i < processedText.length(); i++){
		if ( Character.isUpperCase(processedText.charAt(i)) ){
			numMaiuscole++;
		}
	}
	
	JsonObject obj = new JsonObject();
	obj.addProperty("numeroMaiuscole", numMaiuscole);
	obj.addProperty("testo", processedText);
	
	RequestsManager manager = (RequestsManager) getServletContext().getAttribute("requestsManager");
	manager.terminaRichiesta();
	
    // ---- Stampa in uscita ---------
    out.print(obj.toString());
%>
