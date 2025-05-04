<%@page import="beans.RequestManager"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="classes.Utente"%>
<%
    Utente user = (Utente) session.getAttribute("user");
 
    if (user == null ) {
        response.sendRedirect("index.jsp?error=invalid+action");
        return;
    }
    
    RequestManager richieste = (RequestManager) getServletContext().getAttribute("requestManager");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    <h2>Benvenuto: <%= user.toString() %>!</h2>
    
    <!-- Azioni USER -->
    	
	<form id="inputForm" action="S1" method="GET">
		<input id="inputText" name="fileName" placeholder="nomeFile"></input>
		<input id="targetText" name="target" placeholder="target"></input>
	</form>
    
    <div id="resultDiv">Il tuo risultato verrà mostrato qui</div>

    <!-- Fine azioni USER -->
    <hr>
    <!-- Azioni ADMIN -->
    <%
    	if (user.isAdmin()){
    %>
    	<h2>Richieste che tu, admin, hai fatto dall'inizio dell'esecuzione: <%= user.getRichiesteAdmin() %> </h2>
    	<h2>Richieste degli utenti negli ultimi 60 minuti: <%= richieste.getRichieste() %></h2>
	        
   <%
    	}
    %>
    <!-- Fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
