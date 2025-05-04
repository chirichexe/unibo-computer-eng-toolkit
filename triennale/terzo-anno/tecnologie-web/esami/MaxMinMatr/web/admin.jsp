
<%@page import="beans.Utente"%>
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
    HashMap<HttpSession, Integer> activeSessions = 
        (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");

    // Variabile per gestire eventuali messaggi di feedback
    String message = "";

    // Controlla se è stato inviato un ID sessione da invalidare
    String sessionIdToInvalidate = request.getParameter("sessionId");
    if (sessionIdToInvalidate != null && !sessionIdToInvalidate.isEmpty()) {
        HttpSession sessionToInvalidate = null;

        // Trova la sessione corrispondente
        for (Entry<HttpSession, Integer> entry : activeSessions.entrySet()) {
            if (entry.getKey().getId().equals(sessionIdToInvalidate)) {
                sessionToInvalidate = entry.getKey();
                break;
            }
        }

        // Invalida la sessione se trovata
        if (sessionToInvalidate != null) {
            sessionToInvalidate.invalidate();
            activeSessions.remove(sessionToInvalidate);
            message = "Sessione con ID " + sessionIdToInvalidate + " invalidata con successo.";
        } else {
            message = "Sessione non trovata.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invalidazione Sessione</title>
</head>
<body>
    <h1>Gestione Sessioni Attive</h1>

    <% if (!message.isEmpty()) { %>
        <p style="color: green;"><%= message %></p>
    <% } %>

    <h2>Elenco Utenti Attivi</h2>
    <ul>
        <% 
            for (Entry<HttpSession, Integer> entry : activeSessions.entrySet()) {
            	Integer requestNumber = entry.getValue();
        %>
            <li>ID Sessione: <%= entry.getKey().getId() %> - Utente: <%= requestNumber %></li>
        <% } %>
    </ul>

    <h2>Invalidare una Sessione</h2>
    <form method="post" action="admin.jsp">
        <label for="sessionId">ID Sessione:</label>
        <input type="text" id="sessionId" name="sessionId" required />
        <button type="submit">Invalidare</button>
    </form>
</body>
</html>

