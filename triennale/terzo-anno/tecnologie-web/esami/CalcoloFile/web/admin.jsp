
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
	
	<form action="remove.jsp" method="GET">
		<input type="number" name="numRiga">
		<input type="text" name="fileName">
		<input type="submit">
	</form>
	
	<!-- fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
</body>
</html>
