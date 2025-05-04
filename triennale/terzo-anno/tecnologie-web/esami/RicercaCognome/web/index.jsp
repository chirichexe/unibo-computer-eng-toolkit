<!DOCTYPE html>
<%@page import="beans.Dati"%>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Ricerca cognome</title>
</head>

<!-- Utilizzo dei javaBean per la "persistenza" -->
<jsp:useBean id="dati" class="beans.Dati" scope="session" />


<!-- Richiesta ajax -->
<body>

<!-- Sezione per utenti NON AUTENTICATI: Invio una richiesta POST a una servlet con ajax -->
    <input type="file" id="fileInput" accept=".json">
	<button onclick="sendElenco()">Invia file json</button>
	
	<br><br>
	
	<div id="result">Il risultato verrà mostrato qui...</div>
	
	<br><br><hr/>
	
	<script src="scripts/functions.js"></script>
	
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
