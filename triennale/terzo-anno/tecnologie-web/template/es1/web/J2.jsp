<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" %>

<%
	System.out.println("J2: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
    String processedText = (String) request.getAttribute("processedText");
    String target = request.getParameter("target");

	// ---- Esecuzione programma ----- 
	
	System.out.println(processedText + "- " + target);
	
    // ---- Stampa in uscita ---------
    out.print(processedText);
%>
