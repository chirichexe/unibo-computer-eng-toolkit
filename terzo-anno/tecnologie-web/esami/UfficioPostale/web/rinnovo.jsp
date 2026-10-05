<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale: sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

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
