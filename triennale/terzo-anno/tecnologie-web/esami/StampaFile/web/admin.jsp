
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
	<form method="GET" action="updateNumber.jsp">
		<input type="number" name="numDot" placeholder="massimo numero dottorandi">
		<input type="number" name="numProf" placeholder="massimo numero professori">		
		<input type="submit">		
	</form>
	
	<!-- fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
