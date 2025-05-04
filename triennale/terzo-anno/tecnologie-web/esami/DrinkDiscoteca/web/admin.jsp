
<%@page import="beans.Tavolo"%>
<%@page import="beans.Bar"%>
<%@page import="beans.Utente"%>
<%
	Utente user = (Utente) session.getAttribute("user");
	
	if (user == null || !user.isAdmin() ) {
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
    <h2>Benvenuto, Admin: <%= user.getUsername() %>!</h2>
	<!-- Azioni ADMIN -->
	<ul>
	<%
	Bar bar = (Bar) getServletContext().getAttribute("bar");
	// Gestisco la richiesta di invalidazione
	String idTavolo = request.getParameter("idTavolo");
	if (idTavolo != null){
		bar.invalidaTavolo(idTavolo);
	}
	
	// Mostro i dati
	for ( Tavolo tavolo: bar.getTavoli() ){
		%>
		<li> <%= tavolo.toString() %> </li>
		<%
	}
	%>
	</ul>
	
	<hr/>
	
	<form method="POST" action="admin.jsp" >
		<input type="text" name="idTavolo" />
		<input type="submit" value="Chiudi tavolo">
	</form>
	
	<!-- fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
