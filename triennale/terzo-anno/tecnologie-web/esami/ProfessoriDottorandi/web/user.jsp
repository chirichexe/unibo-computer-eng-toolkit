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
    <p>Scegli i file: </p>
    <form id="dataForm" >
	    <input id="numFiles" type="number"/>
	    <input id="file1" type="text"/>
	    <input id="file2" type="text"/>
	    <input id="file3" type="text"/>
	    <input id="file4" type="text"/>
    </form>
    
    <form id="hiddenForm" method="POST" action="J1.jsp">
	    <input id="jsonData" name="jsonData" type="hidden"/>
    </form>
	
    <!-- Fine azioni USER -->
    
    <hr>
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
