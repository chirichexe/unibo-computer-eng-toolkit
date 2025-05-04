<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" %>

<%
	System.out.println("J2: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
    String processedText = (String) request.getAttribute("processedText");

	// ---- Esecuzione programma ----- 
	
    if (processedText == null) {
        processedText = "";
    }
    Character randomChar = (char) (Math.random() * 26 + 'a');
    processedText = processedText.replace(randomChar.toString(), "");
	
    // ---- Stampa in uscita ---------
    out.print(processedText);
%>
