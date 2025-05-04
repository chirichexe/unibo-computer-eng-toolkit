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
	<h1>Matrice A:</h1>
    <input type="number" id="A00" >
    <input type="number" id="A01" >
    <input type="number" id="A02" >
    <input type="number" id="A03" >
    <br>
    <input type="number" id="A10" >
    <input type="number" id="A11" >
    <input type="number" id="A12" >
    <input type="number" id="A13" >
    <br>
    <input type="number" id="A20" >
    <input type="number" id="A21" >
    <input type="number" id="A22" >
    <input type="number" id="A23" >
    <br>
    <input type="number" id="A30" >
    <input type="number" id="A31" >
    <input type="number" id="A32" >
    <input type="number" id="A33" >
    
   	<h1>Matrice B:</h1>
    <input type="number" id="B00" >
    <input type="number" id="B01" >
    <input type="number" id="B02" >
    <input type="number" id="B03" >
    <br>
    <input type="number" id="B10" >
    <input type="number" id="B11" >
    <input type="number" id="B12" >
    <input type="number" id="B13" >
    <br>
    <input type="number" id="B20" >
    <input type="number" id="B21" >
    <input type="number" id="B22" >
    <input type="number" id="B23" >
    <br>
    <input type="number" id="B30" >
    <input type="number" id="B31" >
    <input type="number" id="B32" >
    <input type="number" id="B33" >

	<button onclick="sendMatrix()">Invia matrice</button>
	
	<div id="result">Il risultato verrà mostrato qui...</div>
	
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
