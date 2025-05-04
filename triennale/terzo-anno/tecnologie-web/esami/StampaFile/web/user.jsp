<%@page import="beans.Utente"%>
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
    <h2>Benvenuto, <%= user.toString() %>!</h2>
    
    <!-- Azioni USER -->
    
	<form method="GET" action="J1.jsp">
		<input type="text" name="file0">
		<input type="text" name="file1">
		<input type="text" name="file2">
		<input type="text" name="file3">
		<input type="number" name="numFile">
		<button type="submit">Invia file</button>
	</form>
    
    <!-- Fine azioni USER -->
    
    <a href="index.jsp">Torna al login</a>
</body>
</html>
