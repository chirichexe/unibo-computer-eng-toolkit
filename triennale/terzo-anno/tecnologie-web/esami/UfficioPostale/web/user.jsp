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
    <p>Scegli il servizio per cui prenotarti: </p>
    <ul>
		<li><a href="rinnovo.jsp">Rinnovo carta</a>
		<br>
		<li><a href="cresidenza.jsp">Cambio residenza</a>
    </ul>
    <!-- Fine azioni USER -->
    
    <hr>
    <a href="index.jsp">Torna al login</a>
</body>
</html>
