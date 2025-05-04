<%@page import="beans.Carrello"%>
<jsp:useBean id="carrello" class="beans.Carrello" scope="application" />

<%@page import="beans.Utente"%>
<%
    Utente user = (Utente) session.getAttribute("user");
 
    if (user == null) {
        response.sendRedirect("index.jsp?error=invalid+action");
        return;
    }
    
    synchronized (application) {
        if (carrello.isPresente()) {
            response.sendRedirect("user.jsp");
        } else {
        	session.setAttribute("group", user.getGroup());
            carrello.setPresente(true);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>

    <script>
    	
    	let groupid = <% session.getAttribute("group"); %>
    	
    	function caricaDati(){
    		getCarrello(groupid);
    	}
    
        window.addEventListener("beforeunload", () => {
        	fetch('exit.jsp', { method: 'POST' })
        });
    </script>
    
<body onload="caricaDati()">
	<div id="carrello"></div>

    <script src="scripts/functions.js"></script>
    <a href="user.jsp">Torna alla home</a>
</body>
</html>
