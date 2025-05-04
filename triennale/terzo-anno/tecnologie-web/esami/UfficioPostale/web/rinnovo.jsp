
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
    <title>Write</title>
</head>
<body onload="rinnovoCarta()">
    <h1>Rinnovo carta in attesa</h1>
    <h2>Tempo rimasto: </h2>
	<p id="tempo"></p>
    
    <a href="user.jsp">Torna alla home</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
