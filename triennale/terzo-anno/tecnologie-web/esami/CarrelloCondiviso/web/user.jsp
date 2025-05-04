	
	<%@page import="beans.Utente"%>
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
		<a href="read.jsp">Visualizza</a>
		<br/>
		<a href="write.jsp">Aggiungi elementi al carrello</a>
	    
	    <!-- Fine azioni USER -->
	    <script src="scripts/functions.js"></script>
	    
	    <a href="index.jsp">Torna al login</a>
	</body>
	</html>
