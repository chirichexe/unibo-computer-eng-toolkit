<%@page import="beans.Utente"%>

<%
    Utente user = (Utente) session.getAttribute("user");
 
    if (user == null || user.isAdmin() ) {
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
    <p>Inserisci il file da cercare: </p>
	<input type="text" id="inputServlet" name="fileName">
	<p>Digita '£££' per inviarlo alla Servlet</p>
	
	
	<br/>
	
	<p id="result">Qui verrà mostrato l'esito</p>
    <!-- Fine azioni USER -->
    
    <hr>
    <a href="index.jsp">Torna al login</a>
    
    <script src="scripts/functions.js"></script>
</body>
</html>
