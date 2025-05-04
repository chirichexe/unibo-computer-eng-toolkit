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
