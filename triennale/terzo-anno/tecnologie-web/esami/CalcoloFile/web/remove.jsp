<%@page import="beans.Utente"%>
//<jsp:useBean id="filesManager" class="beans.FilesManager" scope="application" />

<%
	Utente user = (Utente) session.getAttribute("user");
	
	if (user == null || !user.isAdmin() ) {
	    response.sendRedirect("index.jsp?error=invalid+action");
	    return;
	}
	
	String nomeFile = request.getParameter("fileName");
	int numRiga = Integer.parseInt(request.getParameter("numRiga"));
	
	if (filesManager.eliminaRiga(nomeFile, numRiga)){
		%>
		<p>Riga eliminata con successo</p>
		<%
	} else {
		%>
		<p>Errore nell'eliminazione della riga</p>
		<%
	};
	
	%>
	<html>
	<a href="admin.jsp">Torna indietro</a>
	</html>
	
	


