<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale: sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
	System.out.println("Cambio stato in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
    
	boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));
    
   	// ---- Esecuzione programma -----
   	
   	request.getSession().setAttribute("trovata", newStatus);
   	
   	// ---- Stampa in uscita --------- 
    response.getWriter().println("Settata con successo a " + newStatus);
%>
