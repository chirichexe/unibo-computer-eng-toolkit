
<%@page import="java.util.Set"%>
<%@page import="servlets.WebSocket"%>
<%@page import="javax.websocket.Session"%>
<%@page import="beans.Utente"%>
<%
	Utente user = (Utente) session.getAttribute("user");
	
	if (user == null || !user.isAdmin() ) {
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
    <h2>Benvenuto, Admin: <%= user.getUsername() %>!</h2>
	<!-- Azioni ADMIN -->
	<ul>
	<%
	Set<Session> activeSessions = WebSocket.sessions;
	
	for(Session s : activeSessions){
		%>
		<li>Dispositivo <%= s.getId() %> </li>
		<%
	}
	
	%>
	</ul>
	
	<input id="dispositivo" type="text" placeholder="Dispositivo da disattivare"></input>
	<button onclick="handleDisattiva()" >Disattiva</button>
	
	<!-- fine azioni ADMIN -->
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/websocket.js"></script>
</body>
</html>
