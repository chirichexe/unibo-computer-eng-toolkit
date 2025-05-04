<!DOCTYPE html>

<!-- Utilizzo dei javaBean per la "persistenza" -->
<%@page import="beans.Dati"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />

<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<!-- Richiesta ajax -->
<body>

<!-- Sezione per utenti NON AUTENTICATI -->
    <input type="file" id="fileInput" accept=".json">
	<button onclick="sendFile()">Invia file json</button>
	
	<textarea id="inputArea"></textarea>
	<button onclick="sendText()">Invia testo json</button>
	
	<br><br>
	
	<div id="result">Il risultato verrà mostrato qui...</div>
	
	<br><br><hr/>
	
	<script src="scripts/functions.js"></script>
	
<!-- Sezione per utenti AUTENTICATI -->
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
