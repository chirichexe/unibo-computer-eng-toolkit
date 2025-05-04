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
    <p>Scegli l'azione da compiere: </p>
    <ul>
		<li><a href="write.jsp">Scrivi</a>
		<br>
		<li><a href="read.jsp">Visualizza</a>
    </ul>
    <!-- Fine azioni USER -->
    
    <hr>
    <a href="index.jsp">Torna al login</a>
</body>
</html>
