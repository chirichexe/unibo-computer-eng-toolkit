<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String inputText = request.getParameter("text");
	if (inputText == null){
		response.sendRedirect("index.jsp");
	} else {
		String newText = inputText.replace("a", "b");
		response.sendRedirect("S2?text=" + newText);	
	}	
%>

