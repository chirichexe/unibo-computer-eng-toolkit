<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

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
