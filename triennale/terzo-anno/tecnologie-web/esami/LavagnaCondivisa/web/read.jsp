
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
    <title>Read</title>
</head>
<body>
    <h2>Sei nella sezione di lettura!</h2>
    
    <!-- Inizio componenti lettura -->
    
    <div id="data"></div>
    
    <!-- Fine componenti lettura -->
    
    <a href="user.jsp">Torna alla home</a>
    <script src="scripts/interval.js"></script>
</body>
</html>
