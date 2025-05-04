<%@page import="classes.Utente"%>
<%
    Utente user = (Utente) session.getAttribute("user");
 
    if (user == null || user.isAdmin() ) {
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
    <h2>Benvenuto: <%= user.toString() %>!</h2>
    
    <!-- Azioni USER -->
    
    <button onclick=" sendData('testo', 'testo di prova' )">Invia testo</button>
    
    <div id="resultDiv"></div>

    <!-- Fine azioni USER -->
    
    <hr>
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
