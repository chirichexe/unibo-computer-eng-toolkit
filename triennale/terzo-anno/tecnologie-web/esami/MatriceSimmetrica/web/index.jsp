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
	<div style="display: flex">
		<input id="00"/>
		<input id="01"/>
		<input id="02"/>
		<input id="03"/>
		<input id="04"/>
		<input id="05"/>
	</div>
	
		<div style="display: flex">
		<input id="10"/>
		<input id="11"/>
		<input id="12"/>
		<input id="13"/>
		<input id="14"/>
		<input id="15"/>
	</div>
	
		<div style="display: flex">
		<input id="20"/>
		<input id="21"/>
		<input id="22"/>
		<input id="23"/>
		<input id="24"/>
		<input id="25"/>
	</div>
	
		<div style="display: flex">
		<input id="30"/>
		<input id="31"/>
		<input id="32"/>
		<input id="33"/>
		<input id="34"/>
		<input id="35"/>
	</div>
	
		<div style="display: flex">
		<input id="40"/>
		<input id="41"/>
		<input id="42"/>
		<input id="43"/>
		<input id="44"/>
		<input id="45"/>
	</div>
	
		<div style="display: flex">
		<input id="50"/>
		<input id="51"/>
		<input id="52"/>
		<input id="53"/>
		<input id="54"/>
		<input id="55"/>
	</div>
	
	<button onclick="sendMatrix()">Invia Matrice al server</button>
	
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
