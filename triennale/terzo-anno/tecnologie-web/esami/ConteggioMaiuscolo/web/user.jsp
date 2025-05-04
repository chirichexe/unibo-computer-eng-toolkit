<%@page import="beans.Utente"%>
<jsp:useBean id="requestManager" class="beans.RequestManager" scope="application" />
<%
    Utente user = (Utente) session.getAttribute("user");
 
    if (user == null ) {
        response.sendRedirect("index.jsp?error=invalid+action");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    <h2>Benvenuto, <%= user.toString() %>!</h2>
    
    <!-- Azioni USER -->
    <p>Scegli i dati: </p>
	<form method="POST" action="S1" id="fileForm">
		<input type="text" name="target" ></input>
		<input type="text" id="nomeFile" name="nomeFile" ></input>
	</form>
	
    <!-- Fine azioni USER -->
    
    <% if ( user.isAdmin() ) { %>
    <h1>Admin: </h1>
    <%= requestManager.toString() %>
    <% } %>
    
    <hr>
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
