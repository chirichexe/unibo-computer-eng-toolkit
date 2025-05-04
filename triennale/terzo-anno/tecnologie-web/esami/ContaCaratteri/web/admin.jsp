
<%@page import="java.util.List"%>
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
    HashMap<HttpSession, List< Integer>> activeSessions = 
        (HashMap<HttpSession, List< Integer>>) context.getAttribute("activeSessions");

%>
<!DOCTYPE html>
<html>
<head>
    <title>Invalidazione Sessione</title>
</head>
<body>
    <h2>Elenco Utenti Attivi</h2>
    <ul>
        <% 
            for (Entry<HttpSession, List< Integer>> entry : activeSessions.entrySet()) {
            	List< Integer> requestNumber = entry.getValue();
        %>
            <li>ID Sessione: <%= entry.getKey().getId() %> - 
            tot. caratteri letti: <%= requestNumber.get(0) %>
            tot. caratteri mai. letti: <%= requestNumber.get(1) %>
            tot. caratteri min. letti: <%= requestNumber.get(2) %>
            </li>
        <% } %>
    </ul>

</body>
</html>

