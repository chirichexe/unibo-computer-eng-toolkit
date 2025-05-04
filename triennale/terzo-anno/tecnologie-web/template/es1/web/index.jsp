<!DOCTYPE html>

<!-- Utilizzo dei javaBean -->
<%@page import="beans.Dati"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />
<jsp:useBean id="groupsManager" class="beans.GroupsManager" scope="application" />

<!-- Inizio codice html -->
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<body>

<!-- Sezione utenti non autenticati -->
<div id="notAuthenticated">
	<h1>Sezione utenti non autenticati</h1>
	<!-- 
	
	<form id="inputForm" action="J1.jsp" method="GET">
		<textarea name="text" id="inputText" placeholder="Verrà inviato a J1 -> S2 con INCLUDE"></textarea>
	</form>
	 -->
	
	<hr/>
	
	<form id="inputForm" action="S1" method="GET">
		<textarea name="text" id="inputText" placeholder="Verrà inviato a S1 -> J2 con FORWARD"></textarea>
	</form>
	
</div>

<hr/>
<!-- Sezione di autenticazione utenti -->
<div id="login">
	<h1>Devi autenticarti? Accedi qui</h1>
    
    <form action="loginServlet" method="POST">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <button type="submit">Login</button>
    </form>
    
    <% 
        String error = request.getParameter("error");
        if ("invalid action".equals(error)) {
    %>
        <p style="color: red">Errore: azione non valida</p>
    <% 
        } else if ("invalid credentials".equals(error)){
    %>
     	<p style="color: red">Errore: Credenziali non valide</p>
    <%
        }
    %>
</div>
<script src="scripts/functions.js"></script>

</body>
</html>
