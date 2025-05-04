<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
	System.out.println("J1: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
    
	String inputText = request.getParameter("text");
    
   	// ---- Esecuzione programma -----
   	
   	for ( int i  = 0; i< 4; i++) {
   		
	    Character randomChar = (char) (Math.random() * 26 + 'a'); 
	    inputText = inputText.replace(randomChar.toString(), "");
    	RequestDispatcher dispatcher = request.getRequestDispatcher("S2");
    	request.setAttribute("processedText", inputText);
   		dispatcher.include(request, response);
	    
   	}
   	
   	// ---- Stampa in uscita --------- 
    response.getWriter().println("Tutti hanno completato!");
%>
