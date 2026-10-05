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
    <title>Home</title>
</head>
<body onload="mostraElencoRichieste()">
    <h2>Benvenuto, Admin: <%= user.getUsername() %>!</h2>
	<!-- Azioni ADMIN -->
	<p id="elencoRichieste"></p>
	
	<!-- fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
