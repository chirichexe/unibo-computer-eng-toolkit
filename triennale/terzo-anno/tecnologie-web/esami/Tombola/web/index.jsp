<!DOCTYPE html>

<!-- Utilizzo dei javaBean -->
<%@page import="beans.Dati"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />

<!-- Inizio codice html -->
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<body>

<!-- Sezione utenti non autenticati WEBSOCKET -->

<div id="webSocket">
	<p id="status">In attesa di altri utenti...</p>
	<p id="numbers"></p>
	<button onclick="enterHandler()" >Entra nella tombola</button>
	<button onclick="actionHandler()" >Dichiara tombola</button>
	<button onclick="leaveHandler()" >Abbandona</button>
</div>

<script src="scripts/websocket.js"></script>

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

</body>
</html>
