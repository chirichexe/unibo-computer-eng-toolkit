
<%@page import="beans.Utente, beans.SessionData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap, java.util.Map.Entry, java.util.Optional, javax.servlet.http.HttpSession"%>

<%
	Utente user = (Utente) session.getAttribute("user");
	
	if (user == null ) {
	    response.sendRedirect("index.jsp?error=invalid+action");
	    return;
	}
%>

<%
    // Ottieni il contesto della servlet e la lista delle sessioni attive
    ServletContext context = getServletContext();
    HashMap<HttpSession, SessionData> activeSessions = 
        (HashMap<HttpSession, SessionData>) context.getAttribute("activeSessions");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invalidazione Sessione</title>
</head>
<body>
    <h1>Gestione Sessioni Attive</h1>
    <h2>Elenco Utenti Attivi</h2>
    <ul>
        <% 
            for (Entry<HttpSession, SessionData> entry : activeSessions.entrySet()) {
            	String sessionData = entry.getValue().toString();
        %>
            <li>ID Sessione: <%= entry.getKey().getId() %> - Utente: <%= sessionData %></li>
        <% } %>
    </ul>
</body>
</html>

