
<%@page import="beans.Utente"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />
<jsp:useBean id="groupsManag" class="w" scope="application" />
<%
	Utente user = (Utente) session.getAttribute("user");
	
	if ( user == null ) {
	    response.sendRedirect("index.jsp?error=invalid+action");
	    return;
	}  else {
		if (!groupsManager.isFree() && 
			    groupsManager.getUtenteEditing().get().getUsername().equals(user.getUsername())) {

			System.out.println("Non puoi modificare, sta già modificando l'utente " + groupsManager.getUtenteEditing().get() + " tu sei " + user );
		    response.sendRedirect("user.jsp");
		    return;
		} else {			
			groupsManager.setIsEditing(user);
		}
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Write</title>
</head>
<body onload='fetchLavagna()'>
    <h2>Benvenuto nella sezione di scrittura!</h2>
	
	<!-- inizio azioni scrittura -->
	<form method="POST" action="dataServlet">
		<textarea id="spazioLavagna" name="elemento"></textarea>
		<input type="submit" value="Invia">
	</form>
	
	<!-- fine azioni scrittura-->
    
    <a href="user.jsp">Torna alla home</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
