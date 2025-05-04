<%@page import="beans.Utente"%>
<%
    Utente user = (Utente) session.getAttribute("user");
	
    if (user == null) {
        response.sendRedirect("index.jsp?error=invalid+action");
        return;
    } else {
        session.setAttribute("group", user.getGroup());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    
    <!-- Azioni USER -->
    
    <h1>Lista della spesa condivisa:</h1>
    <div id="carrello"></div>
    
    <!-- Fine azioni USER -->
    
    <script src="scripts/functions.js"></script>
    <script>
	    let carrelloId = "<%= session.getAttribute("group") %>"; // ID del carrello
	
	    let interval = setInterval(() => {
	    	getCarrello(carrelloId);
	    }, 1000);
    </script>
    
    <a href="user.jsp">Torna alla home</a>
</body>
</html>
