<!DOCTYPE html>

<!-- Utilizzo dei javaBean per la "persistenza" -->
<%@page import="beans.Dati"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />
<jsp:useBean id="bar" class="beans.Bar" scope="application" />

<!-- Inizio codice html -->

<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<body>

<!-- Sezione utenti non autenticati -->
<%
	
	String idTavolo = (String) request.getSession().getAttribute("idTavolo");
	if (idTavolo == null){
		
		%>
		<h1>Crea o aggiungi un tavolo</h1>
		<form method="POST" action="dataServlet">
			<input type="number" name="numTavolo" >
			<input type="submit" value="Aggiungi">
		</form>
		<% 
	} else {
%>
		<h1> Bentornato, il tuo tavolo � <%= idTavolo %>, scegli cosa vuoi</h1>
		<form method="GET" action="dataServlet">
			<input type="text" name="nomeDrink" >
			<input type="submit" value="Invia nome del drink">
		</form>
		
		<hr/>
		
		<br/>
		<button onclick="richiediPrezzoPersonale()" >Richiedi prezzo per i miei drink</button>
		<br/>
		<button  onclick="richiediPrezzoTavolo()">Richiedi prezzo per i drink del mio tavolo</button>
		<p id="result"></p>
<%
	}
%>
	
	

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
